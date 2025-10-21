# Watrie - Monitoring Air IoT

Aplikasi Flutter untuk monitoring data sensor IoT kualitas air (pH, Suhu, Mineral).

## Fitur

- 📊 **Dashboard Riwayat**: Tampilan tabel data sensor dengan pagination
- 📅 **Filter Tanggal**: Filter data berdasarkan tanggal tertentu
- 💾 **Export Data**: Simpan riwayat data (fitur akan segera hadir)
- 📱 **Responsive Design**: UI yang clean dan modern

## Prerequisites

- Flutter SDK installed (https://flutter.dev)
- Add Flutter to PATH

## Quick Start

```powershell
cd "c:\Users\LENOVO\OneDrive\Documents\Kuliah semester 6\compro\flutter_framework"
flutter pub get
flutter run
```

## Struktur Proyek

```
lib/
├── main.dart                          # Entry point aplikasi
├── src/
│   ├── app.dart                       # MaterialApp wrapper
│   ├── models/
│   │   └── sensor_reading.dart        # Model data sensor
│   ├── services/
│   │   └── sensor_service.dart        # Service untuk fetch data (mock/API)
│   └── widgets/
│       └── riwayat_page.dart          # Halaman riwayat data sensor
```

## Data Sensor

Aplikasi ini menampilkan data sensor dengan fields:
- **pH**: Tingkat keasaman air (6.0 - 8.5)
- **Suhu**: Temperatur air dalam Celsius (20-35°C)
- **Mineral**: Kandungan mineral dalam ppm (50-250 ppm)
- **Tanggal**: Tanggal pengukuran
- **Pukul**: Waktu pengukuran

## Integrasi dengan IoT Device

Saat ini aplikasi menggunakan data mock/dummy. Untuk menghubungkan dengan device IoT:

1. Buka `lib/src/services/sensor_service.dart`
2. Ganti method `getAllReadings()`, `getReadingsByDate()`, dll dengan HTTP request ke API IoT device
3. Contoh:

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

static Future<List<SensorReading>> getAllReadings() async {
  final response = await http.get(Uri.parse('http://your-iot-device-ip/api/readings'));
  final List<dynamic> jsonData = json.decode(response.body);
  return jsonData.map((json) => SensorReading.fromJson(json)).toList();
}
```

## Customization

### Mengubah jumlah data per halaman
Edit `_itemsPerPage` di `riwayat_page.dart`:
```dart
final int _itemsPerPage = 20; // default: 10
```

### Menambahkan field sensor baru
1. Tambahkan property di `sensor_reading.dart`
2. Update UI tabel di `riwayat_page.dart`
3. Update service untuk fetch field baru

## Testing

```powershell
flutter test
```

## Next Steps

- [ ] Integrasi dengan REST API IoT device
- [ ] Implementasi real-time updates (WebSocket/MQTT)
- [ ] Export data ke CSV/Excel
- [ ] Grafik visualisasi data sensor
- [ ] Notifikasi jika nilai sensor abnormal
- [ ] Authentication & multi-user support

