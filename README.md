# NooraSense - Premium Food Intelligence Demo App

A production-ready Flutter 3.24+ demo application showcasing AI-first conversational UX for food material scanning and analysis.

## 🎯 Core Features

- **AI-Chat-First Interface**: Home screen is a conversational assistant, not a traditional dashboard
- **Hidden Demo Material Config**: Pre-configured material for scanning simulation (no UI picker)
- **Premium Scan Flow**: 3-second animated progress with calibration → analyzing → complete phases
- **Rich Result Cards**: Interactive cards in chat showing parameters, AI insights, and actions
- **Mock Health Integrations**: Apple Health, Google Fit, MyFitnessPal toggle connections

## 🏗️ Architecture

```
lib/
├── core/
│   ├── config/demo_config.dart      # Hidden demo material configuration
│   ├── theme/app_theme.dart         # Tesla/Instagram-tier theming
│   └── utils/                       # Haptics, formatters
├── data/
│   ├── models/                      # MaterialResult, ChatMessage
│   └── services/                    # IScannerService, IHealthSyncService
├── features/
│   ├── chat_home/                   # AI-first home screen
│   ├── scan/                        # Progress animation & logic
│   ├── result/                      # Rich result card component
│   └── health_sync/                 # Health app integration UI
├── app_router.dart                  # go_router configuration
└── main.dart                        # App entry point
```

### Tech Stack
- **State Management**: flutter_riverpod (notifier/state providers)
- **Routing**: go_router (declarative, typed routes)
- **Local DB**: isar (ready for integration)
- **Animations**: flutter_animate + built-in animations
- **Theming**: flex_color_scheme + google_fonts (Inter)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.24+
- Dart 3.5+
- iOS 15+ / Android API 21+

### Installation

```bash
# Clone repository
cd noorasense

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Demo Configuration

The app uses a **HIDDEN** pre-configured material for scanning. To change the demo material:

1. Open `lib/core/config/demo_config.dart`
2. Modify the constant:
   ```dart
   const String kDemoTargetMaterial = 'apple'; // Change to: 'banana', 'chicken', 'salmon'
   ```
3. Hot reload or restart the app

**Available materials:**
- `apple` - Organic Red Apple (default)
- `banana` - Premium Banana
- `chicken` - Fresh Chicken Breast
- `salmon` - Atlantic Salmon Fillet

## 📱 User Flow

1. **Launch** → AI greeting message appears in chat
2. **Tap Scan Button** (FAB or quick action) → Navigate to scan screen
3. **3-Second Animation** → Calibrating → Analyzing → Complete
4. **Auto-Navigate** → Result card appears in chat stream
5. **Interact** → Save, Share, or Sync to Health Apps
6. **Health Sync** → Toggle connections, mock sync animation

## 🎨 Design Principles

- **Minimalist**: Zero clutter, focused content
- **Glassmorphism**: Subtle transparency and blur effects
- **8px Grid**: Consistent spacing throughout
- **System Fonts**: Inter font family via Google Fonts
- **60fps Animations**: Smooth transitions and micro-interactions
- **Haptic Feedback**: Tactile responses on key interactions

## 🔧 Mock Services

### Scanner Service
Located in `lib/data/services/i_scanner.dart`

```dart
// Current: DemoScannerService (simulates 3s scan)
// Production: Replace with hardware integration
// 1. Connect to spectral sensor via platform channels
// 2. Capture raw spectral data
// 3. Send to AI backend for analysis
// 4. Return MaterialResult with real confidence scores
```

### Health Sync Service
Located in `lib/data/services/i_health_sync.dart`

```dart
// Current: MockHealthSyncService (simulates connections)
// Production: Integrate with actual APIs
// 1. Use health_connector for HealthKit/Google Fit
// 2. Request proper permissions
// 3. Map nutrition data to platform schemas
// 4. Handle background sync
```

## 📦 Dependencies

See `pubspec.yaml` for full list. Key packages:

| Package | Version | Purpose |
|---------|---------|---------|
| flutter_riverpod | ^2.5.1 | State management |
| go_router | ^14.2.0 | Navigation |
| flutter_animate | ^4.5.0 | Animations |
| flex_color_scheme | ^7.3.1 | Theming |
| google_fonts | ^6.2.1 | Inter font |

## 🎯 Production Checklist

Before deploying to production:

- [ ] Replace `DemoScannerService` with actual hardware integration
- [ ] Replace `MockHealthSyncService` with HealthKit/Google Fit APIs
- [ ] Add Isar database initialization and schemas
- [ ] Implement real AI backend communication
- [ ] Add authentication and user accounts
- [ ] Implement actual share functionality
- [ ] Add analytics and crash reporting
- [ ] Configure app icons and splash screens
- [ ] Add localization support
- [ ] Implement accessibility features

## 📝 License

Proprietary - NooraSense Demo Application

---

**Built with ❤️ using Flutter**
