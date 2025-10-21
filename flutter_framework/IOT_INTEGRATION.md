# Integrasi dengan IoT Device

Panduan untuk menghubungkan aplikasi Flutter ini dengan perangkat IoT Anda.

## Opsi 1: REST API

Jika IoT device Anda memiliki REST API endpoint:

### 1. Install package HTTP

Tambahkan di `pubspec.yaml`:
```yaml
dependencies:
  http: ^1.1.0
```

### 2. Update SensorService

Edit `lib/src/services/sensor_service.dart`:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sensor_reading.dart';

class SensorService {
  static const String baseUrl = 'http://192.168.1.100:8080'; // IP IoT device Anda
  
  static Future<List<SensorReading>> getAllReadings() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/readings'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => SensorReading.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  
  static Future<List<SensorReading>> getReadingsByDate(DateTime date) async {
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/readings?date=$dateStr'),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => SensorReading.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
```

### 3. Format JSON yang Diharapkan

IoT device harus mengirim data dalam format:

```json
[
  {
    "ph": 7.2,
    "suhu": 28.5,
    "mineral": 125.0,
    "tanggal": "2025-10-20T14:30:00Z"
  },
  {
    "ph": 7.1,
    "suhu": 28.3,
    "mineral": 120.0,
    "tanggal": "2025-10-20T14:00:00Z"
  }
]
```

## Opsi 2: MQTT (Real-time)

Untuk monitoring real-time menggunakan MQTT:

### 1. Install package MQTT

```yaml
dependencies:
  mqtt_client: ^10.0.0
```

### 2. Buat MQTT Service

```dart
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  late MqttServerClient client;
  
  Future<void> connect() async {
    client = MqttServerClient('broker.hivemq.com', '');
    client.port = 1883;
    
    try {
      await client.connect();
    } catch (e) {
      print('Error: $e');
      client.disconnect();
    }
    
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      client.subscribe('watrie/sensor/data', MqttQos.atLeastOnce);
    }
  }
  
  Stream<String> getMessages() {
    return client.updates!.map((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
      return payload;
    });
  }
}
```

## Opsi 3: WebSocket

Untuk koneksi WebSocket real-time:

### 1. Install package WebSocket

```yaml
dependencies:
  web_socket_channel: ^2.4.0
```

### 2. Buat WebSocket Service

```dart
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/sensor_reading.dart';

class WebSocketService {
  late WebSocketChannel channel;
  
  void connect(String url) {
    channel = WebSocketChannel.connect(Uri.parse(url));
  }
  
  Stream<SensorReading> getReadings() {
    return channel.stream.map((data) {
      final json = jsonDecode(data);
      return SensorReading.fromJson(json);
    });
  }
  
  void disconnect() {
    channel.sink.close();
  }
}
```

## Opsi 4: Firebase Realtime Database

Untuk menggunakan Firebase sebagai backend:

### 1. Setup Firebase

```yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_database: ^10.4.0
```

### 2. Buat Firebase Service

```dart
import 'package:firebase_database/firebase_database.dart';
import '../models/sensor_reading.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  
  Stream<List<SensorReading>> getReadings() {
    return _database.child('sensor_readings').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];
      
      return data.entries.map((entry) {
        return SensorReading.fromJson(
          Map<String, dynamic>.from(entry.value as Map)
        );
      }).toList();
    });
  }
  
  Future<void> addReading(SensorReading reading) async {
    await _database.child('sensor_readings').push().set(reading.toJson());
  }
}
```

## Testing Koneksi

### Menggunakan Postman atau curl

Test API endpoint Anda:

```bash
curl http://192.168.1.100:8080/api/readings
```

### Menggunakan MQTT Explorer

Download MQTT Explorer untuk test MQTT broker dan melihat messages.

## Troubleshooting

### CORS Error (Web)

Jika deploy ke web dan ada CORS error, pastikan server IoT mengizinkan CORS:

```dart
// Di server IoT (contoh Express.js)
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  next();
});
```

### Network Permission (Android)

Tambahkan di `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

### iOS Permission

Tambahkan di `ios/Runner/Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

## Contoh Arduino/ESP32 Backend

Contoh kode untuk ESP32 yang mengirim data ke REST API:

```cpp
#include <WiFi.h>
#include <HTTPClient.h>

const char* ssid = "YourWiFi";
const char* password = "YourPassword";
const char* serverUrl = "http://your-server.com/api/readings";

void sendSensorData(float ph, float temp, float mineral) {
  HTTPClient http;
  http.begin(serverUrl);
  http.addHeader("Content-Type", "application/json");
  
  String payload = "{\"ph\":" + String(ph) + 
                   ",\"suhu\":" + String(temp) + 
                   ",\"mineral\":" + String(mineral) + 
                   ",\"tanggal\":\"" + getISOTimestamp() + "\"}";
  
  int httpResponseCode = http.POST(payload);
  http.end();
}
```

## Next Steps

1. Tentukan metode koneksi (REST API, MQTT, WebSocket, atau Firebase)
2. Setup backend/broker sesuai metode yang dipilih
3. Update `sensor_service.dart` dengan implementasi yang sesuai
4. Test koneksi dan data flow
5. Deploy aplikasi ke device mobile
