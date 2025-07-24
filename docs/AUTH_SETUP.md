# 🔐 Setup Authentication dengan Supabase OAuth

## 📋 Prerequisites

Sebelum menjalankan aplikasi, Anda perlu mengkonfigurasi beberapa hal:

### 1. Supabase Project Setup ✅ (SUDAH DIKONFIGURASI)

Berdasarkan file `.env` Anda, Supabase sudah dikonfigurasi:
- ✅ SUPABASE_URL: `https://brghgmleqkppibcebcix.supabase.co`
- ✅ SUPABASE_ANON_KEY: Sudah tersedia

### 2. Google OAuth Setup (PERLU DIKONFIGURASI)

#### A. Google Cloud Console Setup:

1. **Buka Google Cloud Console**
   - Pergi ke https://console.cloud.google.com
   - Login dengan akun Google Anda

2. **Buat atau Pilih Project**
   - Klik dropdown project di header
   - Pilih project yang ada atau buat baru
   - Catat Project ID untuk referensi

3. **Enable Google+ API**
   - Pergi ke "APIs & Services" > "Library"
   - Cari "Google+ API" atau "People API"
   - Klik "Enable"

4. **Buat OAuth 2.0 Credentials**
   - Pergi ke "APIs & Services" > "Credentials"
   - Klik "+ CREATE CREDENTIALS" > "OAuth 2.0 Client IDs"
   
   **Untuk Android:**
   - Application type: Android
   - Package name: `com.abuamar.agenda.agenda`
   - SHA-1 certificate fingerprint: [Lihat cara mendapatkan SHA-1 di bawah]
   
   **Untuk iOS:**
   - Application type: iOS
   - Bundle ID: `com.abuamar.agenda.agenda`

5. **Dapatkan SHA-1 Fingerprint untuk Android**
   ```bash
   # Debug keystore (untuk development)
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   
   # Atau menggunakan gradlew
   cd android
   ./gradlew signingReport
   ```

6. **Copy Client ID**
   - Setelah membuat credentials, copy "Client ID"
   - Update file `.env` dengan Client ID tersebut

#### B. Supabase OAuth Configuration:

1. **Login ke Supabase Dashboard**
   - Pergi ke https://supabase.com
   - Login dan pilih project Anda

2. **Setup Google OAuth Provider**
   - Pergi ke "Authentication" > "Providers"
   - Cari "Google" dan klik "Configure"
   - Aktifkan Google provider
   - Masukkan "Client ID" dan "Client Secret" dari Google Cloud Console
   - Authorized redirect URLs tambahkan:
     ```
     https://brghgmleqkppibcebcix.supabase.co/auth/v1/callback
     ```

3. **Configure Redirect URLs**
   - Tambahkan redirect URLs untuk mobile:
     ```
     com.abuamar.agenda.agenda://auth/callback
     ```

### 3. Update Environment Configuration

Edit file `.env` di root project:

```env
# Supabase Configuration (SUDAH OK)
SUPABASE_URL=https://brghgmleqkppibcebcix.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# Google OAuth Configuration (UPDATE INI)
GOOGLE_CLIENT_ID=your_google_client_id_from_google_cloud_console
GOOGLE_CLIENT_SECRET=your_google_client_secret_from_google_cloud_console

# Development/Production Environment
ENVIRONMENT=development
DEBUG_MODE=true
```

### 4. Android Configuration

#### A. Update `android/app/build.gradle`:

```gradle
android {
    compileSdk 34
    
    defaultConfig {
        applicationId "com.abuamar.agenda.agenda"
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "1.0"
    }
}
```

#### B. Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Internet permission -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

    <application
        android:label="Agenda"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme">
            
            <!-- Main intent filter -->
            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
            
            <!-- Deep link for OAuth callback -->
            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="com.abuamar.agenda.agenda" />
            </intent-filter>
            
        </activity>
    </application>
</manifest>
```

### 5. iOS Configuration (Opsional)

Update `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>google</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.abuamar.agenda.agenda</string>
        </array>
    </dict>
</array>
```

## 🚀 Testing Authentication

### 1. Run Aplikasi

```bash
# Debug mode
flutter run

# Specific device
flutter run -d android
flutter run -d chrome  # untuk web testing
```

### 2. Expected Flow

1. **Splash Screen** (2 detik)
   - App loading dengan logo
   - Check authentication status

2. **Auth Screen** (jika belum login)
   - Tampil tombol "Continue with Google"
   - Klik untuk memulai OAuth flow

3. **Google OAuth** 
   - Browser/WebView terbuka
   - Login dengan Google account
   - Authorize aplikasi

4. **Redirect ke Home**
   - Setelah sukses login
   - Navigate ke HomeView
   - User data tersimpan lokal

### 3. Debug Tips

#### A. Check Logs:
```bash
# Android
flutter logs

# Atau lihat di Android Studio/VS Code console
```

#### B. Common Issues:

**Error: "OAuth provider not found"**
- Pastikan Google provider diaktifkan di Supabase
- Check redirect URLs sudah benar

**Error: "Invalid client ID"**
- Pastikan Client ID di .env file benar
- Check package name di Google Cloud Console

**Error: "SHA-1 fingerprint invalid"**
- Generate ulang SHA-1 fingerprint
- Update di Google Cloud Console

**Error: "Deep link not working"**
- Check AndroidManifest.xml intent-filter
- Pastikan scheme URL benar

## 🔧 Troubleshooting Commands

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Check SHA-1 fingerprint
cd android
./gradlew signingReport

# Check package name
grep applicationId android/app/build.gradle

# Test deep link (Android)
adb shell am start \
  -W -a android.intent.action.VIEW \
  -d "com.abuamar.agenda.agenda://auth/callback" \
  com.abuamar.agenda.agenda
```

## 📞 Need Help?

Jika mengalami masalah:

1. **Check error logs** di console
2. **Verify all configurations** di checklist di atas
3. **Test di browser** dulu (flutter run -d chrome)
4. **Check Supabase dashboard** untuk auth logs

## ✅ Quick Checklist

- [ ] Google Cloud Project created
- [ ] OAuth credentials configured
- [ ] SHA-1 fingerprint added
- [ ] Supabase Google provider enabled
- [ ] `.env` file updated with Client ID
- [ ] AndroidManifest.xml updated
- [ ] Deep link intent-filter added
- [ ] App runs without errors
- [ ] OAuth flow working
- [ ] Redirect to home after login

Setelah semua dikonfigurasi, aplikasi akan memiliki flow authentication yang lengkap!
