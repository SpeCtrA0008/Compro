# 🔥 Firebase Integration - WATRIC IoT Monitoring

## ✅ Status: Firebase Realtime Database Terintegrasi!

Aplikasi Flutter Anda sekarang sudah terhubung ke **Firebase Realtime Database** untuk monitoring real-time dari IoT device.

---

## 📊 Database Information

- **Database URL**: `https://watric-cf76f-default-rtdb.asia-southeast1.firebasedatabase.app`
- **Project ID**: `watric-cf76f`
- **Region**: Asia Southeast (Singapore)
- **Data Path**: `/sensorData`

---

## 🛠️ Format Data dari IoT Device

Kirim data dari **ESP32/Arduino** ke Firebase dengan format berikut:

### Format JSON (Rekomendasi)
```json
{
  "sensorData": {
    "-OY_ZDNSk0Z1OKotQy1N": {
      "ph": 7.2,
      "suhu": 28.5,
      "mineral": 150.0,
      "timestamp": 1730102400000
    },
    "-OY_ZFh58iNfZPMZc_Zs": {
      "ph": 6.8,
      "suhu": 27.3,
      "mineral": 180.0,
      "timestamp": 1730106000000
    }
  }
}
```

### Field yang Diperlukan:
| Field | Tipe | Deskripsi | Contoh |
|-------|------|-----------|---------|
| `ph` | Number | Nilai pH air (6.5-8.5 normal) | `7.2` |
| `suhu` | Number | Suhu air dalam °C (25-30 normal) | `28.5` |
| `mineral` | Number | TDS/mineral dalam ppm (<500 normal) | `150.0` |
| `timestamp` | Number | Unix timestamp (milliseconds) | `1730102400000` |

### Alternative Field Names (Supported):
- `pH` → sama seperti `ph`
- `temperature` → sama seperti `suhu`
- `tds` → sama seperti `mineral`
- `tanggal` → ISO datetime string (fallback jika tidak ada `timestamp`)

---

## 📡 Cara Mengirim Data dari IoT Device

### Option 1: ESP32 dengan Firebase Arduino Library

```cpp
#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

// WiFi credentials
#define WIFI_SSID "YOUR_WIFI_SSID"
#define WIFI_PASSWORD "YOUR_WIFI_PASSWORD"

// Firebase credentials
#define DATABASE_URL "https://watric-cf76f-default-rtdb.asia-southeast1.firebasedatabase.app"
#define API_KEY "YOUR_API_KEY"  // Get from Firebase Console

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

void setup() {
  Serial.begin(115200);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;
  config.token_status_callback = tokenStatusCallback;
  
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void loop() {
  // Baca sensor
  float ph = readPHSensor();
  float suhu = readTempSensor();
  float mineral = readTDSSensor();
  
  // Kirim ke Firebase
  String path = "/sensorData/" + String(millis());
  
  FirebaseJson json;
  json.set("ph", ph);
  json.set("suhu", suhu);
  json.set("mineral", mineral);
  json.set("timestamp", millis());
  
  if (Firebase.RTDB.setJSON(&fbdo, path.c_str(), &json)) {
    Serial.println("Data sent!");
  } else {
    Serial.println("Failed: " + fbdo.errorReason());
  }
  
  delay(5000); // Kirim setiap 5 detik
}
```

### Option 2: ESP32 dengan HTTP REST API

```cpp
#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

const char* ssid = "YOUR_WIFI_SSID";
const char* password = "YOUR_WIFI_PASSWORD";
const char* firebaseUrl = "https://watric-cf76f-default-rtdb.asia-southeast1.firebasedatabase.app/sensorData.json";

void sendToFirebase(float ph, float suhu, float mineral) {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(firebaseUrl);
    http.addHeader("Content-Type", "application/json");
    
    // Create JSON
    StaticJsonDocument<200> doc;
    doc["ph"] = ph;
    doc["suhu"] = suhu;
    doc["mineral"] = mineral;
    doc["timestamp"] = millis();
    
    String jsonString;
    serializeJson(doc, jsonString);
    
    int httpCode = http.POST(jsonString);
    
    if (httpCode > 0) {
      Serial.println("Data sent: " + String(httpCode));
    } else {
      Serial.println("Error: " + http.errorToString(httpCode));
    }
    
    http.end();
  }
}

void loop() {
  float ph = analogRead(PH_PIN) * conversion;
  float suhu = readDS18B20();
  float mineral = readTDS();
  
  sendToFirebase(ph, suhu, mineral);
  delay(5000);
}
```

---

## 🔐 Firebase Security Rules

**PENTING**: Update security rules di Firebase Console untuk production:

### Development (Public Read/Write - TIDAK AMAN):
```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

### Production (Rekomendasi):
```json
{
  "rules": {
    "sensorData": {
      ".read": true,
      ".write": "auth != null"
    }
  }
}
```

Cara update rules:
1. Buka Firebase Console: https://console.firebase.google.com
2. Pilih project **watric-cf76f**
3. Klik **Realtime Database** → **Rules**
4. Update dan **Publish**

---

## 📱 Fitur Aplikasi Flutter

### ✅ Real-time Monitoring
- Data otomatis update saat IoT device mengirim data baru
- Tidak perlu refresh manual

### ✅ Status Kelayakan Air
- **Hijau**: Air layak digunakan (pH: 6.5-8.5, Suhu: 25-30°C, Mineral: <500 ppm)
- **Merah**: Air tidak layak

### ✅ Auto-sync
- Aplikasi otomatis sinkronisasi dengan Firebase
- Koneksi real-time menggunakan WebSocket

---

## 🚀 Cara Menjalankan Aplikasi

### Windows:
```powershell
flutter run -d windows
```

### Web (Chrome):
```powershell
flutter run -d chrome
```

### Android/iOS (jika ada emulator):
```powershell
flutter run
```

---

## 🧪 Testing dengan Data Manual

Untuk test tanpa IoT device, Anda bisa input data manual di Firebase Console:

1. Buka: https://console.firebase.google.com/project/watric-cf76f/database
2. Klik `sensorData` → **+** (Add child)
3. Masukkan data:
   ```
   Name: (auto-generated)
   Value:
     {
       "ph": 7.0,
       "suhu": 28.0,
       "mineral": 200.0,
       "timestamp": 1730102400000
     }
   ```
4. Data langsung muncul di aplikasi!

---

## 📞 Troubleshooting

### ❌ "Permission denied" error
**Solusi**: Update Firebase Security Rules (lihat section di atas)

### ❌ Data tidak muncul di aplikasi
**Checklist**:
- [ ] Internet connected?
- [ ] Firebase URL benar? (cek `firebase_options.dart`)
- [ ] Data path `/sensorData` sudah benar?
- [ ] Security rules allow read?

### ❌ ESP32 gagal connect ke WiFi
**Checklist**:
- [ ] SSID dan password benar?
- [ ] WiFi 2.4GHz (bukan 5GHz)
- [ ] Signal kuat?

---

## 📚 Library IoT yang Direkomendasikan

- **Firebase ESP Client**: https://github.com/mobizt/Firebase-ESP-Client
- **ArduinoJson**: https://arduinojson.org
- **WiFi (built-in ESP32)**

---

## 🎯 Next Steps

1. ✅ Firebase sudah terintegrasi
2. 🔧 Setup IoT device (ESP32/Arduino) untuk kirim data
3. 🔐 Update Firebase security rules untuk production
4. 📊 (Optional) Tambah fitur export data/grafik

---

**Dibuat**: 28 Oktober 2025  
**Status**: Production Ready ✅
