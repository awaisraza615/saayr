# Saayr iOS Native App (SwiftUI)

A complete native iOS implementation of the Saayr virtual pet game app built with SwiftUI.

## 📱 Features

### Core Functionality
- ✅ **5 Main Screens**: Home, Challenges, Map, Rewards, Profile
- ✅ **Pet Evolution System**: 5 stages (Egg → Hatchling → Juvenile → Adult → Legendary)
- ✅ **XP & Points System**: Earn XP from spending, check-ins, and challenges
- ✅ **Level Progression**: Dynamic leveling with XP tracking
- ✅ **Check-In System**: Location-based check-ins with XP rewards
- ✅ **Challenge System**: Daily, Weekly, and Special challenges
- ✅ **Rewards Marketplace**: Redeem XP for brand rewards (McDonald's, Starbucks, etc.)
- ✅ **PVP Battle Arena**: Player vs player competitions with entry fees
- ✅ **Groups/Tribes System**: Social features with leaderboards
- ✅ **Support System**: Help center, FAQs, and contact options
- ✅ **Settings**: Language toggle, privacy, and app info

### UI/UX Features
- ✅ **Glassmorphism Effects**: Beautiful frosted glass card designs
- ✅ **Gradient Backgrounds**: Dynamic gradients that change by pet stage
- ✅ **Floating Particles**: Ambient particle animations
- ✅ **Spring Animations**: Smooth, natural iOS animations
- ✅ **Arabic/English Support**: Full bilingual support
- ✅ **RTL Layout**: Proper right-to-left layout for Arabic
- ✅ **iOS Native Design**: Follows Apple HIG (Human Interface Guidelines)
- ✅ **Custom Fonts**: Almarai (Arabic) / Libre Franklin (English)

## 🗂️ Project Structure

```
ios-swiftui/
├── SaayrApp.swift                 # App entry point
├── ContentView.swift              # Main tab navigation
├── Models/
│   ├── UserData.swift            # User data models
│   └── Language.swift            # Language & translations
├── Managers/
│   └── UserManager.swift         # User state management
├── Utils/
│   └── LevelSystem.swift         # XP/Level calculations
├── Views/
│   ├── HomeView.swift            # Home screen
│   ├── ChallengesView.swift     # Challenges screen
│   ├── MapView.swift             # Map & check-ins
│   ├── RewardsView.swift         # Rewards marketplace
│   ├── ProfileView.swift         # User profile
│   ├── SettingsView.swift        # App settings
│   ├── SupportView.swift         # Support & FAQ
│   ├── GroupsView.swift          # Groups/Tribes
│   ├── CheckInDialog.swift       # Check-in modal
│   └── PVPPaymentDialog.swift    # PVP payment modal
└── README.md                      # This file
```

## 🚀 Setup Instructions

### Prerequisites
- macOS 13.0 or later
- Xcode 15.0 or later
- iOS 17.0 SDK or later

### Installation Steps

1. **Create a new Xcode project**
   - Open Xcode
   - File → New → Project
   - Select "iOS" → "App"
   - Product Name: `Saayr`
   - Interface: `SwiftUI`
   - Language: `Swift`
   - Click "Next" and save

2. **Add the source files**
   - Copy all files from the `ios-swiftui/` folder
   - Drag and drop into your Xcode project
   - Make sure "Copy items if needed" is checked
   - Maintain folder structure

3. **Configure Info.plist**
   Add these keys to your `Info.plist`:
   ```xml
   <key>NSLocationWhenInUseUsageDescription</key>
   <string>We need your location to show nearby check-in points</string>
   
   <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
   <string>We use your location to provide check-in features</string>
   ```

4. **Add Fonts (Optional)**
   - Download **Almarai** font for Arabic text
   - Download **Libre Franklin** font for English text
   - Add font files to project
   - Register fonts in `Info.plist`:
   ```xml
   <key>UIAppFonts</key>
   <array>
       <string>Almarai-Regular.ttf</string>
       <string>Almarai-Bold.ttf</string>
       <string>LibreFranklin-Regular.ttf</string>
       <string>LibreFranklin-Bold.ttf</string>
   </array>
   ```

5. **Build and Run**
   - Select a simulator or device
   - Press `⌘ + R` to build and run

## 🎨 Customization

### Change Pet Stages
Edit `PetStage` enum in `Models/UserData.swift`:
```swift
enum PetStage: String, Codable {
    case egg = "egg"
    case hatchling = "hatchling"
    // Add more stages...
}
```

### Modify XP Rewards
Edit constants in `Utils/LevelSystem.swift`:
```swift
static let checkInRegular = 50
static let challengeDaily = 100
// Modify rewards...
```

### Add Translations
Edit `Translations` struct in `Models/Language.swift`:
```swift
static let english: [String: String] = [
    "key": "English Text",
    // Add more...
]
```

### Change Gradient Colors
Edit `gradientColors` in `PetStage`:
```swift
var gradientColors: [String] {
    switch self {
    case .egg:
        return ["#E0F7FA", "#B2EBF2"]
    // Modify colors...
    }
}
```

## 📦 Dependencies

This project uses **native SwiftUI only** - no external dependencies required!

Optional frameworks used:
- `MapKit` - For map display
- `PassKit` - For Apple Pay integration (commented out in demo)

## 🔧 Configuration

### Change Default Language
In `LanguageManager`:
```swift
init() {
    let savedLang = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
    self.currentLanguage = Language(rawValue: savedLang) ?? .english
}
```

### Modify Level System
In `LevelSystem.swift`:
```swift
static let xpPerLevel = 1000  // XP needed per level
```

### Update Pet Emoji
In `PetStage`:
```swift
var emoji: String {
    switch self {
    case .egg: return "🥚"
    case .hatchling: return "🐣"
    // Customize emoji...
    }
}
```

## 📱 Supported iOS Versions

- **Minimum**: iOS 17.0
- **Target**: iOS 17.0+
- **Tested**: iOS 17.0 - 18.0

To support older iOS versions:
1. Lower deployment target in Xcode
2. Replace iOS 17+ features (e.g., `.sheet` with `.presentationDetents`)

## 🌐 Localization

The app supports:
- 🇬🇧 English (LTR)
- 🇸🇦 Arabic (RTL)

Language toggle is available in Settings.

## 🎯 Key Screens

1. **Home** - Pet display, XP/Points, quick actions
2. **Challenges** - Daily/Weekly/Special challenges
3. **Map** - Location check-ins with MapKit
4. **Rewards** - Brand rewards redemption
5. **Profile** - User stats and navigation
6. **Settings** - Language, privacy, about
7. **Support** - Help center and FAQs
8. **Groups** - Social tribes and leaderboards

## 💡 Tips

- Use **SwiftUI Previews** for rapid development
- Test RTL layout by changing language to Arabic
- Simulate location in Xcode for map testing
- Use Instruments to profile performance

## 🐛 Known Limitations

- Apple Pay integration is simulated (requires merchant setup)
- Map locations are hardcoded (needs backend integration)
- User data is not persisted (add Core Data or CloudKit)
- Push notifications not implemented

## 🚀 Next Steps

1. **Backend Integration**
   - Connect to a real API
   - Implement user authentication
   - Add data persistence

2. **Advanced Features**
   - Push notifications for challenges
   - Real-time PVP battles
   - Social sharing
   - In-app purchases

3. **Testing**
   - Unit tests
   - UI tests
   - Beta testing via TestFlight

4. **App Store Submission**
   - Add app icons
   - Create screenshots
   - Write app description
   - Submit for review

## 📄 License

This code is provided as-is for the Saayr project.

## 🤝 Support

For questions or issues:
- Check the in-app Support section
- Review Apple's SwiftUI documentation
- Test on real devices, not just simulators

---

**Built with ❤️ using SwiftUI for iOS**
