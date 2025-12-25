# Saayr iOS - Quick Start Guide

## ⚡ Get Running in 5 Minutes

### Step 1: Create Xcode Project (2 minutes)

1. Open **Xcode**
2. Click **File** → **New** → **Project**
3. Select **iOS** → **App**
4. Fill in details:
   - **Product Name**: `Saayr`
   - **Team**: Your Apple Developer account
   - **Organization Identifier**: `com.yourcompany`
   - **Interface**: `SwiftUI`
   - **Language**: `Swift`
   - **Storage**: None
5. Click **Next**, choose location, click **Create**

### Step 2: Add Files (2 minutes)

1. Open Finder, navigate to the `ios-swiftui/` folder
2. Select all `.swift` files
3. Drag them into your Xcode project navigator
4. **Check**: ✅ Copy items if needed
5. **Check**: ✅ Create groups
6. **Check**: ✅ Add to target: Saayr
7. Click **Finish**

### Step 3: Configure Permissions (1 minute)

1. Open **Info.plist** in Xcode
2. Add these keys (Right-click → Add Row):

| Key | Type | Value |
|-----|------|-------|
| Privacy - Location When In Use Usage Description | String | We need your location to show nearby check-in points |
| Privacy - Location Always and When In Use Usage Description | String | We use your location for check-in features |

### Step 4: Build & Run! ▶️

1. Select simulator: **iPhone 15 Pro** (or any iOS 17+ device)
2. Press **⌘ + R** or click the **Play** button
3. Wait for build to complete
4. **App launches!** 🎉

---

## 🎮 Test the App

### Try These Features:

1. **Home Screen**
   - See your pet (🥚 Egg stage at Level 1)
   - View XP: 289, Points: 2, Streak: 3
   - Tap "Check In" → Select location → Check in (+50 XP)
   - Tap "Battle Arena" → See PVP payment dialog

2. **Challenges Tab**
   - View Daily/Weekly/Special challenges
   - See progress bars
   - Tap "Claim" on completed challenges

3. **Map Tab**
   - See Riyadh locations on map
   - Tap location pins
   - View nearby locations at bottom
   - Tap to check in

4. **Rewards Tab**
   - Scroll through brand rewards
   - See XP costs
   - Try redeeming (need more XP!)

5. **Profile Tab**
   - View detailed stats grid
   - Tap "My Groups" → See tribes
   - Tap "Support" → Read FAQs
   - Tap "Settings" → Toggle language to Arabic

### Test Language Switch:

1. Go to **Profile** tab
2. Tap **Settings** (⚙️ icon)
3. Tap **Language** row
4. Watch entire app flip to Arabic with RTL layout!
5. Toggle back to English

---

## 📁 Project Structure Overview

```
Saayr/
├── SaayrApp.swift              ← App entry point
├── ContentView.swift           ← Tab navigation
├── Models/
│   ├── UserData.swift         ← Data models
│   └── Language.swift         ← Translations
├── Managers/
│   └── UserManager.swift      ← State management
├── Utils/
│   └── LevelSystem.swift      ← XP calculations
└── Views/
    ├── HomeView.swift         ← 🏠 Home
    ├── ChallengesView.swift   ← 🎯 Challenges
    ├── MapView.swift          ← 🗺️ Map
    ├── RewardsView.swift      ← 🎁 Rewards
    ├── ProfileView.swift      ← 👤 Profile
    ├── SettingsView.swift     ← ⚙️ Settings
    ├── SupportView.swift      ← ❓ Support
    ├── GroupsView.swift       ← 👥 Groups
    ├── CheckInDialog.swift    ← Modal
    └── PVPPaymentDialog.swift ← Modal
```

---

## 🎨 Quick Customization

### Change Pet Emoji

**File**: `Models/UserData.swift`

Find `PetStage` enum:
```swift
var emoji: String {
    switch self {
    case .egg: return "🥚"        // ← Change this
    case .hatchling: return "🐣"  // ← Change this
    case .juvenile: return "🦅"   // ← Change this
    case .adult: return "🦅"      // ← Change this
    case .legendary: return "👑"  // ← Change this
    }
}
```

### Change XP Rewards

**File**: `Utils/LevelSystem.swift`

```swift
static let checkInRegular = 50      // ← Change value
static let challengeDaily = 100     // ← Change value
static let pvpWin = 200            // ← Change value
```

### Change Background Colors

**File**: `Models/UserData.swift`

Find `gradientColors`:
```swift
var gradientColors: [String] {
    switch self {
    case .egg:
        return ["#E0F7FA", "#B2EBF2"]  // ← Change hex colors
    // ... more stages
    }
}
```

---

## 🔧 Common First-Time Issues

### ❌ Build Failed - "Cannot find type 'LanguageManager'"

**Fix**: Make sure all files are added to your target
1. Select file in navigator
2. Check "Target Membership" in right panel
3. Enable ✅ Saayr

### ❌ Map Not Showing

**Fix**: Add location permissions to Info.plist (see Step 3 above)

### ❌ Fonts Look Wrong

**Solution**: This is normal! Custom fonts are optional. The app uses system fonts as fallback.

To add custom fonts:
1. Download Almarai (Arabic) and Libre Franklin (English)
2. Add `.ttf` files to project
3. Register in Info.plist
4. Update font references in code

### ❌ Preview Crashed

**Fix**: 
1. Click "Resume" button
2. Or rebuild: **⌘ + B**
3. Previews use: `#Preview { ViewName() }`

---

## 📱 Test on Real Device

### Requirements:
- iPhone running iOS 17+
- USB cable
- Free Apple Developer account

### Steps:
1. Connect iPhone to Mac
2. **Settings** → **Privacy & Security** → **Developer Mode** → Enable
3. In Xcode: Select your iPhone from device list
4. Press **⌘ + R**
5. If prompted: **Trust** this computer on iPhone
6. App installs and runs!

---

## 🎯 Next Steps

### Beginner Tasks:
- [ ] Change pet emoji to your favorite animal
- [ ] Modify XP reward values
- [ ] Change gradient background colors
- [ ] Add your own translation keys

### Intermediate Tasks:
- [ ] Add a new challenge to the list
- [ ] Create a new reward in the marketplace
- [ ] Add a new FAQ to support section
- [ ] Customize the stats displayed on profile

### Advanced Tasks:
- [ ] Connect to a real backend API
- [ ] Implement user authentication
- [ ] Add push notifications
- [ ] Integrate Firebase or Supabase
- [ ] Add more pet stages
- [ ] Implement real PVP battles

---

## 📚 Learn More

- **Full Documentation**: See `README.md`
- **Implementation Guide**: See `IMPLEMENTATION_GUIDE.md`
- **SwiftUI Basics**: [Apple's SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- **iOS Design**: [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

---

## 💡 Pro Tips

1. **Use Previews**: Edit code and see changes instantly
   ```swift
   #Preview {
       HomeView()
           .environmentObject(LanguageManager())
           .environmentObject(UserManager())
   }
   ```

2. **Live Preview**: Enable by pressing **⌥ + ⌘ + P**

3. **Quick Build**: Press **⌘ + B** to check for errors without running

4. **Clean Build**: **Shift + ⌘ + K** if you have weird issues

5. **Simulator Controls**:
   - Shake: **⌃ + ⌘ + Z**
   - Home: **⌘ + H**
   - Lock: **⌘ + L**
   - Screenshot: **⌘ + S**

6. **Test Arabic**: Toggle language in Settings to see full RTL layout

7. **Debug Prints**: Add `print()` statements to see values in console

---

## 🎉 You're Ready!

You now have a fully functional iOS app with:
- ✅ 5 main screens (Home, Challenges, Map, Rewards, Profile)
- ✅ Pet evolution system
- ✅ XP and leveling
- ✅ Bilingual support (English/Arabic)
- ✅ Glassmorphism UI
- ✅ Smooth animations
- ✅ Check-in system
- ✅ Challenges
- ✅ Rewards marketplace
- ✅ Groups/Tribes
- ✅ Support center
- ✅ Settings

**Time to make it your own!** 🚀

---

Need help? Check:
1. `README.md` - Setup and features
2. `IMPLEMENTATION_GUIDE.md` - Deep technical guide
3. Apple's documentation
4. This file - Quick reference

**Happy coding!** 💻✨
