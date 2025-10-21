# Quick Start - Run Flutter di Browser

## 🌐 Run di Edge/Chrome

### Run di Edge:
```powershell
cd "c:\Users\LENOVO\OneDrive\Documents\Kuliah semester 6\compro\flutter_framework"
flutter run -d edge
```

### Run di Chrome:
```powershell
flutter run -d chrome
```

### Run di browser default:
```powershell
flutter run -d web-server
# Lalu buka: http://localhost:XXXX di browser apapun
```

## 🔥 Hot Reload di Browser

Setelah app running:
- **Tekan `r`** → Hot reload (reload UI)
- **Tekan `R`** → Hot restart (restart app)
- **Tekan `q`** → Quit/stop app

**Atau di browser:**
- Edit kode → Save → Browser otomatis reload! ⚡

## 📱 Run di Emulator Android

### List devices tersedia:
```powershell
flutter devices
```

### Run di emulator:
```powershell
flutter run -d emulator-5554
# atau
flutter run -d android
```

## 🎯 Quick Commands

### Check semua devices:
```powershell
flutter devices

# Output contoh:
# Edge (web)                 • edge        • web-javascript • Microsoft Edge 120.0.2210.144
# Chrome (web)               • chrome      • web-javascript • Google Chrome 120.0.6099.130  
# sdk gphone64 x86 64 (mobile) • emulator-5554 • android-x64 • Android 13 (API 33)
```

### Run di device tertentu:
```powershell
# Edge
flutter run -d edge

# Chrome
flutter run -d chrome

# Android Emulator
flutter run -d emulator-5554

# Pilih manual (interactive)
flutter run
# Lalu pilih nomor device yang mau dipakai
```

## 🐛 Troubleshooting

### "No supported devices connected"
```powershell
# Cek devices
flutter devices

# Kalau kosong, pastikan:
# 1. Browser terinstall (Edge/Chrome)
# 2. Atau emulator Android sudah running
```

### Build web lambat pertama kali
- Normal! Build pertama ~1-2 menit
- Build selanjutnya lebih cepat (~5-10 detik)
- Hot reload super cepat! (<1 detik)

### Browser tidak auto-open
```powershell
# Cari output seperti ini:
# "Running on http://localhost:12345"

# Lalu manual buka URL tersebut di browser
```

### Error: "web not configured"
```powershell
flutter create . --platforms=web
flutter pub get
flutter run -d edge
```

## ✨ Development Tips

### Best Practice:
1. **Pilih satu device** untuk development (Edge/Chrome/Emulator)
2. **Run app** dengan `flutter run -d <device>`
3. **Edit code** di VS Code
4. **Save** (Ctrl+S)
5. **Tekan `r`** di terminal untuk hot reload
6. **Lihat perubahan** instant! ⚡

### Rekomendasi Device:

**Browser (Edge/Chrome):**
- ✅ Cepat startup (~30 detik)
- ✅ Hot reload instant
- ✅ Mudah inspect element (F12)
- ❌ Beberapa plugin ga support (camera, GPS, etc)

**Android Emulator:**
- ✅ Support semua fitur Android
- ✅ Test seolah-olah di HP
- ❌ Startup agak lama (~1-2 menit)
- ❌ Butuh RAM cukup (4GB+)

**HP Android Fisik:**
- ✅✅ Paling cepat & smooth
- ✅✅ Test di device asli
- ✅ Hot reload super instant
- ⚠️ Perlu kabel USB

## 🎨 Current App Features

Aplikasi Watrie monitoring IoT ini punya:
- 📊 Tabel data sensor (pH, Suhu, Mineral)
- 📅 Filter berdasarkan tanggal
- 📄 Pagination
- 💾 Button export (UI ready)
- 🎯 Responsive design

## 🔧 Quick Scripts

Save sebagai `dev.ps1`:

```powershell
# Development helper script

param(
    [string]$Device = "edge"
)

cd "c:\Users\LENOVO\OneDrive\Documents\Kuliah semester 6\compro\flutter_framework"

Write-Host "🚀 Starting Flutter app on $Device..." -ForegroundColor Cyan

flutter run -d $Device
```

**Cara pakai:**
```powershell
# Run di Edge
.\dev.ps1

# Run di Chrome
.\dev.ps1 -Device chrome

# Run di Android
.\dev.ps1 -Device android
```

## 📝 Editing Workflow

1. **Buka VS Code:**
   ```powershell
   code "c:\Users\LENOVO\OneDrive\Documents\Kuliah semester 6\compro\flutter_framework"
   ```

2. **Run app di terminal:**
   ```powershell
   flutter run -d edge
   ```

3. **Edit file:**
   - `lib/src/widgets/riwayat_page.dart` - UI halaman riwayat
   - `lib/src/models/sensor_reading.dart` - Model data
   - `lib/src/services/sensor_service.dart` - Service/API

4. **Hot reload:**
   - Save file (Ctrl+S)
   - Tekan `r` di terminal
   - Lihat perubahan! 🎉

## 🎯 Ready to Code!

Setelah app running di browser:
1. Split screen: VS Code (kiri) + Browser (kanan)
2. Edit kode → Save → Hot reload
3. Development super smooth! 🚀

Happy coding! 🎨
