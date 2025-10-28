import 'package:firebase_database/firebase_database.dart';
import '../models/sensor_reading.dart';

class SensorService {
  // Firebase Realtime Database reference
  static final DatabaseReference _database = FirebaseDatabase.instance.ref();
  static final DatabaseReference _sensorDataRef = _database.child('sensorData');

  /// Fetch all sensor readings from Firebase
  static Future<List<SensorReading>> getAllReadings() async {
    try {
      final snapshot = await _sensorDataRef.get();
      
      if (!snapshot.exists) {
        return [];
      }

      final List<SensorReading> readings = [];
      final data = snapshot.value as Map<dynamic, dynamic>?;
      
      if (data != null) {
        data.forEach((key, value) {
          try {
            final reading = _parseSensorData(value);
            if (reading != null) {
              readings.add(reading);
            }
          } catch (e) {
            print('Error parsing reading $key: $e');
          }
        });
      }

      // Sort by date descending (newest first)
      readings.sort((a, b) => b.tanggal.compareTo(a.tanggal));
      return readings;
    } catch (e) {
      print('Error fetching readings: $e');
      return [];
    }
  }

  /// Filter readings by date
  static Future<List<SensorReading>> getReadingsByDate(DateTime date) async {
    final allReadings = await getAllReadings();
    
    return allReadings.where((reading) {
      return reading.tanggal.year == date.year &&
          reading.tanggal.month == date.month &&
          reading.tanggal.day == date.day;
    }).toList();
  }

  /// Filter readings by date range
  static Future<List<SensorReading>> getReadingsByDateRange(
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    final allReadings = await getAllReadings();

    if (startDate == null && endDate == null) {
      return allReadings;
    }

    return allReadings.where((reading) {
      if (startDate != null && reading.tanggal.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && reading.tanggal.isAfter(endDate)) {
        return false;
      }
      return true;
    }).toList();
  }

  /// Stream real-time updates from Firebase
  static Stream<List<SensorReading>> streamReadings() {
    return _sensorDataRef.onValue.map((event) {
      final List<SensorReading> readings = [];
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      
      if (data != null) {
        data.forEach((key, value) {
          try {
            final reading = _parseSensorData(value);
            if (reading != null) {
              readings.add(reading);
            }
          } catch (e) {
            print('Error parsing reading $key: $e');
          }
        });
      }

      readings.sort((a, b) => b.tanggal.compareTo(a.tanggal));
      return readings;
    });
  }

  /// Parse sensor data from Firebase format
  static SensorReading? _parseSensorData(dynamic data) {
    if (data == null) return null;

    try {
      final map = data as Map<dynamic, dynamic>;
      
      // Parse timestamp - support multiple formats
      DateTime timestamp;
      if (map['timestamp'] != null) {
        timestamp = DateTime.fromMillisecondsSinceEpoch(
          (map['timestamp'] as num).toInt(),
        );
      } else if (map['tanggal'] != null) {
        timestamp = DateTime.parse(map['tanggal'].toString());
      } else {
        timestamp = DateTime.now();
      }

      return SensorReading(
        ph: (map['ph'] ?? map['pH'] ?? 7.0) is num 
            ? (map['ph'] ?? map['pH'] ?? 7.0).toDouble() 
            : double.tryParse(map['ph']?.toString() ?? '7.0') ?? 7.0,
        suhu: (map['suhu'] ?? map['temperature'] ?? 25.0) is num
            ? (map['suhu'] ?? map['temperature'] ?? 25.0).toDouble()
            : double.tryParse(map['suhu']?.toString() ?? '25.0') ?? 25.0,
        mineral: (map['mineral'] ?? map['tds'] ?? 0.0) is num
            ? (map['mineral'] ?? map['tds'] ?? 0.0).toDouble()
            : double.tryParse(map['mineral']?.toString() ?? '0.0') ?? 0.0,
        tanggal: timestamp,
      );
    } catch (e) {
      print('Error in _parseSensorData: $e');
      return null;
    }
  }
}
