# Quick Setup WSA untuk Flutter

## After installing WSA from Microsoft Store:

### Step 1: Open WSA Settings
1. Press Windows Key
2. Search: "Windows Subsystem for Android Settings"
3. Click to open

### Step 2: Enable Developer Mode
1. Toggle **"Developer mode"** to ON
2. The subsystem will start automatically
3. Note the IP address shown (example: 127.0.0.1:58526)

### Step 3: Install ADB (Android Debug Bridge)

Run this in PowerShell:
```powershell
# Option 1: Via winget (recommended)
winget install Google.PlatformTools

# Option 2: Via chocolatey
choco install adb -y
```

### Step 4: Connect ADB to WSA

```powershell
# Connect (use the IP from WSA Settings, usually port 58526)
adb connect 127.0.0.1:58526

# Verify connection
adb devices
# Should show: 127.0.0.1:58526	device
```

### Step 5: Run Flutter App!

```powershell
cd "c:\Users\LENOVO\OneDrive\Documents\Kuliah semester 6\compro\flutter_framework"

# Check if WSA is detected
flutter devices

# Run the app
flutter run
```

## 🔥 During Development:

After the app is running:
- Press **`r`** → Hot reload (instant UI update)
- Press **`R`** → Hot restart
- Press **`q`** → Quit app

Edit `lib/src/widgets/riwayat_page.dart`, save, then press `r` to see changes instantly!

## ⚡ Quick Commands Reference:

```powershell
# Start WSA (if not running)
# Open: Windows Subsystem for Android Settings → Turn On

# Connect ADB
adb connect 127.0.0.1:58526

# Check connection
adb devices

# Run Flutter app
cd "c:\Users\LENOVO\OneDrive\Documents\Kuliah semester 6\compro\flutter_framework"
flutter run

# Hot reload
r

# Quit
q
```

## 🐛 Common Issues:

**WSA not showing in flutter devices?**
```powershell
adb kill-server
adb start-server
adb connect 127.0.0.1:58526
flutter devices
```

**App won't install?**
```powershell
# Accept Android licenses
flutter doctor --android-licenses
# Press 'y' for all prompts
```

**WSA very slow?**
- Open WSA Settings
- Change "Subsystem resources" to "Continuous"
- Allocate more RAM if needed

## 📱 Ready to Code!

Once everything is setup:
1. Edit your Dart files in VS Code
2. Save (Ctrl+S)
3. Press `r` in terminal
4. See changes instantly in WSA! 🎉
