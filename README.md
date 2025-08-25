# Weather (Flutter)

A polished, multi-platform weather app built with Flutter and Riverpod. Search and save cities, see current conditions, hourly trends, and a 7‑day summary with a modern, glass/gradient UI and subtle Lottie animations.

## Features

- Add, view, and manage multiple cities (reorder and remove)
- Current conditions with feels-like, humidity, wind, pressure, sunrise/sunset
- Hourly forecast (next periods from OpenWeather 3‑hour forecast)
- 7‑day summary (derived from 3‑hour forecast buckets)
- Temperature units: °C/°F
- Theme: Light, Dark, or System
- Animated, condition-aware backgrounds (Lottie + gradients)
- Persistent settings and cities via SharedPreferences

## Tech stack

- Flutter 3 (Dart >= 3.4)
- State: flutter_riverpod
- Routing: go_router
- Storage: shared_preferences
- Networking: http
- UI: weather_icons, lottie, flutter_svg, Material 3

## API key (OpenWeather)

This app uses OpenWeather APIs. Provide your API key before running.

Quick start (current project setup):
- Edit `lib/secrets.dart` and set your key:
	- `const openWeatherApiKey = 'YOUR_API_KEY';`
- Do not commit real keys to public repos. Consider `.gitignore` or using `--dart-define` in production.

Note: Daily forecast here is approximated by grouping OpenWeather 3‑hour forecast entries per day (no One Call lat/lon used).

## Getting started

Prereqs:
- Flutter SDK installed and `flutter doctor` passing
- An OpenWeather API key

Install deps:

```powershell
flutter pub get
```

Run (choose any supported device):

```powershell
# Windows desktop
flutter run -d windows

# Android (emulator or device)
flutter run -d android

# iOS (simulator, on macOS)
flutter run -d ios

# Web (Chrome)
flutter run -d chrome
```

Build releases:

```powershell
# Android APK (release)
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (requires Xcode/macOS)
flutter build ipa --release

# Windows
flutter build windows --release

# Web
flutter build web --release
```

## Project structure (high level)

- `lib/`
	- `main.dart`: App entry, theming, router
	- `core/`
		- `router/app_router.dart`: Routes (home, city, search, settings)
		- `theme/app_theme.dart`: Material 3 light/dark themes
	- `data/`
		- `models/weather_models.dart`: Weather DTOs
		- `repositories/weather_repository.dart`: OpenWeather calls and transforms
	- `presentation/`
		- `screens/`: Home, City details, Search, Settings
		- `providers/`: Theme, settings, UI state
		- `widgets/`: Animated background, glass cards, icons, helpers
	- `secrets.dart`: OpenWeather API key (replace with your key)
- `assets/`: Lottie animation and app icon

## Configuration notes

- Launcher icons are configured via `flutter_launcher_icons` (see `pubspec.yaml`).
- Saved preferences keys: theme_mode_v1, unit_v1, cities_v1.
- Initial default city: Kolkata (can be removed in Settings).

## Testing

Run default widget tests:

```powershell
flutter test
```

## Troubleshooting

- Network/API errors: verify your OpenWeather key and free tier limits.
- City not found: ensure correct spelling and availability in OpenWeather.
- Android build issues: run `flutter clean; flutter pub get` and ensure Android SDK/NDK installed.
- iOS: open the iOS workspace in Xcode after `pod install` (Flutter handles this) and ensure signing is configured.

## Privacy

The app calls OpenWeather APIs over HTTPS. No personal data is collected; saved cities and preferences are stored locally on device.

## Credits

- Weather data: OpenWeather (https://openweathermap.org/)
- Icons/animations: weather_icons, Lottie files

---

Made with Flutter and Riverpod.
