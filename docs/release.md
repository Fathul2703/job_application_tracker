# Release builds

Signing credentials are personal and never committed. Set them up once per
machine.

## Android

1. Create an upload keystore (keep it and its passwords safe — losing it means
   you can't update the app on Google Play):

   ```bash
   keytool -genkey -v -keystore ~/keys/job-tracker-upload.jks \
     -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. Copy `android/key.properties.example` to `android/key.properties` and fill in
   the absolute path and passwords. `key.properties`, `*.jks` and `*.keystore`
   are git-ignored.

3. Build:

   ```bash
   flutter build appbundle --release   # for Google Play
   flutter build apk --release         # for direct install
   ```

Without `key.properties`, release builds are signed with the debug key so they
run locally but can't be published.

## iOS

1. Join the Apple Developer Program and open `ios/Runner.xcworkspace` in Xcode.
2. Runner target → *Signing & Capabilities* → pick your Team. The bundle ID is
   `io.github.fathul2703.jobtracker`.
3. Build and upload:

   ```bash
   flutter build ipa --release
   ```

   then upload `build/ios/ipa/*.ipa` with Transporter or `xcrun altool`.

## Versioning

Bump `version:` in `pubspec.yaml` (`x.y.z+build`) **and** `AppInfo` in
`lib/core/app_info.dart` — `test/unit/app_info_test.dart` fails if they differ.
