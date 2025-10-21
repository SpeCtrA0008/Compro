import 'dart:math';
import '../models/sensor_reading.dart';

class SensorService {
  // Simulasi data sensor - nanti bisa diganti dengan API call ke IoT device
  static List<SensorReading> _mockData = [];

  static void _generateMockData() {
    if (_mockData.isNotEmpty) return;

    final random = Random();
    final now = DateTime.now();

    // Generate 50 data points untuk demo
    for (int i = 0; i < 50; i++) {
      _mockData.add(SensorReading(
        ph: 6.0 + random.nextDouble() * 2.5, // pH 6.0 - 8.5
        suhu: 20.0 + random.nextDouble() * 15.0, // Suhu 20-35°C
        mineral: 50.0 + random.nextDouble() * 200.0, // Mineral 50-250 ppm
        tanggal: now.subtract(Duration(
          days: random.nextInt(30),
          hours: random.nextInt(24),
          minutes: random.nextInt(60),
        )),
      ));
    }

    // Sort by date descending (newest first)
    _mockData.sort((a, b) => b.tanggal.compareTo(a.tanggal));
  }

  /// Fetch all sensor readings
  static Future<List<SensorReading>> getAllReadings() async {
    _generateMockData();
    // Simulasi network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockData);
  }

  /// Filter readings by date
  static Future<List<SensorReading>> getReadingsByDate(DateTime date) async {
    _generateMockData();
    await Future.delayed(const Duration(milliseconds: 500));

    return _mockData.where((reading) {
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
    _generateMockData();
    await Future.delayed(const Duration(milliseconds: 500));

    if (startDate == null && endDate == null) {
      return List.from(_mockData);
    }

    return _mockData.where((reading) {
      if (startDate != null && reading.tanggal.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && reading.tanggal.isAfter(endDate)) {
        return false;
      }
      return true;
    }).toList();
  }
}
