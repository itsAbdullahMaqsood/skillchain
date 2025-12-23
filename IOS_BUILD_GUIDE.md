# iOS Build Guide for Skill Chain App

## Overview
To build an iOS app for distribution on real devices, you need to set up code signing with Apple Developer account. This guide will help you through the process.

## Prerequisites
1. **Apple Developer Account** ($99/year)
   - Sign up at: https://developer.apple.com/programs/
   - Or use a free Apple ID for development (limited to 7 days)

2. **Xcode** (already installed ✓)
3. **Valid Bundle Identifier** (unique app ID)

## Step 1: Open Project in Xcode

```bash
cd ios
open Runner.xcworkspace
```

**Important:** Always open `.xcworkspace`, not `.xcodeproj`

## Step 2: Configure Signing & Capabilities

1. In Xcode, select **Runner** project in the left navigator
2. Select **Runner** target under "TARGETS"
3. Go to **Signing & Capabilities** tab
4. Check **"Automatically manage signing"**
5. Select your **Team** (your Apple Developer account)
   - If you don't see your team, click "Add Account..." and sign in with your Apple ID
6. Xcode will automatically:
   - Create a Development Certificate
   - Create a Provisioning Profile
   - Set up the Bundle Identifier

## Step 3: Update Bundle Identifier

1. In **Signing & Capabilities**, ensure the Bundle Identifier is unique
2. Current: `com.example.skillchain`
3. Recommended: `com.yourcompany.skillchain` or `com.yourname.skillchain`
4. Make sure it matches across all targets

## Step 4: Build for Device

### Option A: Build IPA for Distribution (App Store/TestFlight)

```bash
flutter build ipa --release
```

The IPA file will be at:
```
build/ios/ipa/skillchain.ipa
```

### Option B: Build for Specific Device

1. Connect your iOS device via USB
2. Trust the computer on your device
3. In Xcode, select your device from the device dropdown
4. Run:
```bash
flutter run --release
```

Or build and install:
```bash
flutter build ios --release
# Then install via Xcode or Xcode Organizer
```

## Step 5: Install on Device

### Via Xcode:
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select your connected device
3. Click the Play button or press `Cmd + R`

### Via IPA File:
1. Use **Apple Configurator 2** or **Xcode Organizer**
2. Or use **TestFlight** for beta testing
3. Or upload to **App Store Connect** for distribution

## Troubleshooting

### "No valid code signing certificates found"
- Make sure you're signed in to Xcode with your Apple ID
- Go to Xcode → Settings → Accounts → Add your Apple ID
- Select your team in Signing & Capabilities

### "Bundle identifier is already in use"
- Change the Bundle Identifier to something unique
- Use reverse domain notation: `com.yourname.skillchain`

### "Provisioning profile doesn't match"
- Let Xcode automatically manage signing
- Or manually create/update provisioning profiles in Apple Developer Portal

### "Device not registered"
- Register your device UDID in Apple Developer Portal
- Or let Xcode automatically register it when you connect

## Free Apple ID (7-day certificates)

If you don't have a paid Apple Developer account:
1. Use your free Apple ID in Xcode
2. Certificates expire after 7 days
3. Limited to 3 apps per device
4. Can't distribute via App Store

## Distribution Methods

### 1. TestFlight (Recommended for Beta)
- Upload IPA to App Store Connect
- Invite testers via email
- Up to 10,000 external testers

### 2. App Store
- Submit for review
- Public distribution
- Requires App Store Review Guidelines compliance

### 3. Enterprise Distribution
- Requires Enterprise Developer Account ($299/year)
- Internal distribution only
- No App Store

### 4. Ad-Hoc Distribution
- Limited to 100 devices
- Requires device UDIDs
- Good for internal testing

## Current Build Status

✅ **Android APK**: Built successfully
- Location: `build/app/outputs/flutter-apk/app-release.apk`
- Size: ~54MB
- Ready for distribution

⚠️ **iOS IPA**: Requires code signing setup
- Follow steps above to configure signing
- Then run: `flutter build ipa --release`

## Quick Start (If you have Apple Developer Account)

```bash
# 1. Open in Xcode and configure signing
open ios/Runner.xcworkspace

# 2. In Xcode:
#    - Select Runner target
#    - Go to Signing & Capabilities
#    - Select your Team
#    - Xcode will auto-configure everything

# 3. Build IPA
flutter build ipa --release

# 4. Find your IPA
ls -lh build/ios/ipa/
```

## Notes

- The app is configured to use the Railway backend: `https://skill-chain-backend-production.up.railway.app`
- All features (login, signup, timecoins, offers, chat) are included
- Learning Skills field is included in signup

