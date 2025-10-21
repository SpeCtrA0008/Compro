# 🚀 Quick Start - Android Emulator untuk Flutter

## ✅ Setup Sudah Selesai!

Android licenses sudah diterima dan emulator **Pixel 4a API 33** sedang booting.

## 📱 Cara Menjalankan App di Emulator

### Step 1: Tunggu Emulator Boot (30-60 detik)
Jendela emulator akan muncul dan menampilkan Android home screen.

### Step 2: Cek Device Terdeteksi
```powershell
flutter devices
```

Harusnya muncul:
```
Pixel 4a API 33 (mobile) • emulator-5554 • android-x86 • Android 13 (API 33)
```

### Step 3: Run Flutter App! 🎉
```powershell
cd "c:\Users\LENOVO\OneDrive\Documents\Kuliah semester 6\compro\flutter_framework"
flutter run
```

App akan otomatis install dan run di emulator!

## 🔥 Hot Reload - Magic Development

Setelah app running di emulator:

1. **Edit kode** di VS Code (misal: `lib/src/widgets/riwayat_page.dart`)
2. **Save** file (Ctrl+S)
3. **Tekan `r`** di terminal
4. **Lihat perubahan** langsung di emulator! ⚡

Keyboard shortcuts di terminal:
- **`r`** → Hot reload (update UI instant tanpa restart app)
- **`R`** → Hot restart (restart app sepenuhnya)
- **`q`** → Quit/stop app
- **`h`** → Help (lihat semua commands)

## 🎯 Quick Commands Reference

```powershell
# Lihat emulator yang tersedia
flutter emulators

# Launch emulator
flutter emulators --launch Pixel_4a_API_33

# Cek devices yang connected
flutter devices

# Run app
cd "c:\Users\LENOVO\OneDrive\Documents\Kuliah semester 6\compro\flutter_framework"
flutter run

# Run dengan verbose output (untuk debugging)
flutter run -v

# Run in release mode (lebih cepat)
flutter run --release
```

## 🔧 Emulator Controls

Di jendela emulator, ada panel samping dengan tools:
- **🔙 Back button**
- **🏠 Home button**
- **📱 Rotate screen** (portrait/landscape)
- **📸 Screenshot**
- **⚙️ Settings**

## 💡 Development Workflow

**Workflow ideal:**

1. **Open VS Code** (kiri) + **Emulator** (kanan) side by side
2. **Run** `flutter run` sekali
3. **Edit** file Dart
4. **Save** (Ctrl+S)
5. **Press** `r` di terminal
6. **See changes** instantly! 🎉

Repeat step 3-6 untuk setiap perubahan.

## 🐛 Troubleshooting

### Emulator tidak muncul di `flutter devices`?

```powershell
# Restart ADB
adb kill-server
adb start-server

# Check lagi
flutter devices
```

### Emulator sangat lambat?

**Enable Hardware Acceleration:**
1. Buka **Android Studio**
2. **Tools** → **AVD Manager**
3. Edit emulator (ikon ✏️)
4. **Show Advanced Settings**
5. **Emulated Performance:**
   - Graphics: **Hardware - GLES 2.0**
   - Boot option: **Cold boot** atau **Quick boot**

### App tidak install / error?

```powershell
# Clean & rebuild
flutter clean
flutter pub get
flutter run
```

### Ingin buat emulator baru?

```powershell
# Buka Android Studio
# Tools → Device Manager → Create Device
# Pilih device (misal: Pixel 7)
# Download system image (API 34 - Android 14)
# Finish

# Atau via command:
flutter emulators --create --name my_pixel
```

## 📊 Tips Performance

**Untuk emulator lebih cepat:**

1. **Allocate RAM:** 4GB minimum (8GB ideal)
2. **Enable Hardware Acceleration** (lihat di atas)
3. **Close apps** lain saat development
4. **Use Cold boot** pertama kali, lalu **Quick boot** selanjutnya

**Di Android Studio AVD Manager:**
- Edit emulator → Advanced Settings
- RAM: **4096 MB** atau **8192 MB**
- VM Heap: **512 MB**
- Internal Storage: **2 GB** (cukup)

## 🎨 Kustomisasi Emulator

Di AVD Manager, bisa edit:
- **Screen size** (misal: 5", 6", 7" tablet)
- **RAM & Storage**
- **Camera** (front/back)
- **Android version** (API 30, 33, 34, dll)

## ✅ Ready to Code!

Emulator sedang booting. Tunggu 30-60 detik, lalu run:

```powershell
flutter devices  # Cek emulator ready
flutter run      # Run app!
```

Selamat coding! 🚀🔥

---

## 📝 Current Project Info

**Project:** Watrie - Monitoring Air IoT
**Location:** `c:\Users\LENOVO\OneDrive\Documents\Kuliah semester 6\compro\flutter_framework`
**Main File:** `lib/src/widgets/riwayat_page.dart`

**Fitur:**
- Tabel data sensor (pH, Suhu, Mineral)
- Date filter
- Pagination
- Mock data (50 entries)

**Next:** Connect to real IoT device! (lihat `IOT_INTEGRATION.md`)
