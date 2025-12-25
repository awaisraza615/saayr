x`# Saayr iOS - Authentication Flow Documentation

## 📱 Complete Phone-Based OTP Authentication

The Saayr iOS app implements a **phone number + OTP (One-Time Password)** authentication flow, which is the primary authentication method for Saudi users.

---

## 🔐 Authentication States

The app has **5 distinct authentication states**:

```swift
enum AuthState {
    case onboarding        // First-time welcome screens
    case phoneEntry        // Phone number input
    case otpVerification   // OTP code verification
    case profileSetup      // New user profile creation
    case authenticated     // Logged in and active
}
```

---

## 📋 Authentication Flow

### Flow Diagram

```
┌─────────────────┐
│  App Launch     │
└────────┬────────┘
         │
         ├─ Has seen onboarding?
         │  ├─ NO  → Onboarding
         │  └─ YES → Phone Entry
         │
         ├─ Is authenticated?
         │  ├─ NO  → Phone Entry
         │  └─ YES → Main App
         │
         v
┌─────────────────┐
│  1. Onboarding  │  (First time only)
└────────┬────────┘
         │ Skip/Complete
         v
┌─────────────────┐
│ 2. Phone Entry  │  (Enter phone number)
└────────┬────────┘
         │ Send OTP
         v
┌─────────────────┐
│ 3. OTP Verify   │  (Enter 6-digit code)
└────────┬────────┘
         │
         ├─ New User? → Profile Setup
         │
         ├─ Existing User? → Main App
         │
         v
┌─────────────────┐
│ 4. Profile      │  (Name, Email, Pet)
│    Setup        │
└────────┬────────┘
         │ Complete
         v
┌─────────────────┐
│ 5. Main App     │  (Home, Challenges, etc.)
└─────────────────┘
```

---

## 🎨 Screen Details

### 1. Onboarding (OnboardingView.swift)

**Purpose**: Welcome new users and explain the app

**Features**:
- 4 slides explaining key features
- Page indicators
- Skip button (jumps to Phone Entry)
- Next/Get Started buttons
- Fully translated (English/Arabic)

**Content**:
1. **Welcome** - Introduction to Saayr
2. **Earn XP** - Explain XP and Points system
3. **Rewards** - Show reward redemption
4. **Pet Evolution** - Show 5 evolution stages

**UI Elements**:
- Large emoji icons
- Title and description per slide
- Gradient background (purple/indigo)
- Glassmorphism design
- Page dots indicator

**User Actions**:
- Swipe between pages
- Tap "Next" to go forward
- Tap "Skip" to jump to phone entry
- Tap "Get Started" on last page

---

### 2. Phone Entry (PhoneAuthView.swift)

**Purpose**: Collect user's phone number

**Features**:
- Country code selector (🇸🇦 +966, 🇦🇪 +971, 🇧🇭 +973, 🇰🇼 +965)
- Phone number input field
- Phone number validation
- Loading state during API call
- Error message display
- Terms & Privacy links

**UI Elements**:
- App logo/icon at top
- Title: "Welcome to Saayr"
- Country code dropdown menu
- Phone number text field
- "Continue" button
- Terms acceptance text

**Validation**:
- Minimum 9 digits required
- Only numeric input
- Cannot proceed with empty phone

**User Actions**:
- Select country code
- Enter phone number
- Tap "Continue" to send OTP
- Review Terms/Privacy

**Demo Behavior**:
- Any phone number accepted
- Simulated 1.5s API call
- Always succeeds (for demo)

---

### 3. OTP Verification (OTPVerificationView.swift)

**Purpose**: Verify phone number with 6-digit OTP

**Features**:
- 6 individual digit input fields
- Auto-focus next field on input
- Countdown timer (60 seconds)
- Resend code option
- Edit phone number option
- Error message display
- Loading state

**UI Elements**:
- Back/"Edit" button to change phone
- SMS icon
- Phone number display
- 6 OTP digit boxes
- Countdown timer
- "Verify" button
- "Resend Code" button

**Behavior**:
- OTP code is 6 digits only
- Each box holds 1 digit
- Auto-advance to next box
- 60-second resend cooldown
- Demo OTP: **123456**

**User Actions**:
- Enter 6-digit code
- Tap "Edit" to change phone number
- Wait for countdown
- Tap "Resend Code" after 60s
- Tap "Verify" to proceed

**Flow After Verification**:
- **New User** (no profile) → Profile Setup
- **Existing User** (has profile) → Main App

---

### 4. Profile Setup (ProfileSetupView.swift)

**Purpose**: Collect profile information for new users

**Features**:
- Full name input
- Email input (with @ validation)
- Pet name input
- Pet type selection (4 choices)
- Form validation
- Error messages
- Loading state

**UI Elements**:
- Title: "Complete Your Profile"
- Full Name text field
- Email text field
- Pet Name text field
- Pet type selection grid (2x2)
- "Complete Setup" button

**Pet Type Options**:
- 🐦 **Bird** (Default)
- 🐱 **Cat**
- 🐶 **Dog**
- 🐰 **Rabbit**

**Validation**:
- Name: Required, not empty
- Email: Required, must contain "@"
- Pet Name: Required, not empty
- Pet Type: Auto-selected (Bird default)

**User Actions**:
- Fill in all fields
- Select pet type
- Tap "Complete Setup"

**Result**:
- Profile saved to UserDefaults
- User marked as authenticated
- Navigate to Main App

---

### 5. Main App (ContentView.swift)

**Purpose**: Core app experience (after authentication)

**Features**:
- 5-tab navigation (Home, Challenges, Map, Rewards, Profile)
- Full app functionality
- Logout option in Settings

---

## 🔧 Technical Implementation

### AuthManager (Managers/AuthManager.swift)

**Responsibilities**:
- Manage authentication state
- Handle state transitions
- Store temporary data
- Validate inputs
- Simulate API calls (demo mode)

**Key Methods**:

```swift
// Onboarding
func completeOnboarding()

// Phone Authentication
func sendOTP()
func validatePhoneNumber() -> Bool

// OTP Verification
func verifyOTP()
func resendOTP()
func editPhoneNumber()

// Profile Setup
func completeProfileSetup()
func validateProfileData() -> Bool

// Session Management
func completeAuthentication()
func logout()
```

**Published Properties**:
```swift
@Published var authState: AuthState
@Published var phoneNumber: String
@Published var countryCode: String
@Published var otpCode: String
@Published var isLoading: Bool
@Published var errorMessage: String?
```

---

## 💾 Data Persistence

### UserDefaults Keys

| Key | Type | Purpose |
|-----|------|---------|
| `isAuthenticated` | Bool | User login status |
| `hasSeenOnboarding` | Bool | Skip onboarding for returning users |
| `hasProfile` | Bool | Check if user completed profile setup |
| `phoneNumber` | String | Stored phone number (with country code) |
| `fullName` | String | User's full name |
| `email` | String | User's email address |
| `petName` | String | User's pet name |
| `petType` | String | User's pet type (Bird/Cat/Dog/Rabbit) |

---

## 🔐 Security Considerations

### Current Implementation (Demo Mode)

⚠️ **For demonstration purposes only!**

- OTP is hardcoded: `123456`
- No actual SMS sending
- No backend validation
- Phone numbers not verified
- Data stored in UserDefaults (unencrypted)

### Production Requirements

✅ **Must implement for production:**

1. **Backend API Integration**
   - Real OTP generation and SMS sending
   - Phone number verification
   - Session token management
   - Rate limiting for OTP requests

2. **Secure Storage**
   - Use **Keychain** for sensitive data
   - Encrypt authentication tokens
   - Secure session management

3. **Phone Number Validation**
   - Verify Saudi phone format
   - Check for valid country codes
   - Prevent duplicate accounts

4. **OTP Security**
   - Random 6-digit code generation
   - Time-limited codes (5-10 minutes)
   - Maximum retry attempts (3-5)
   - Block suspicious activity

5. **Session Management**
   - JWT tokens or similar
   - Refresh token rotation
   - Auto-logout after inactivity
   - Secure logout (clear all data)

---

## 🌐 Supported Countries

Current country codes supported:

| Country | Flag | Code | Format |
|---------|------|------|--------|
| Saudi Arabia | 🇸🇦 | +966 | 5X XXX XXXX |
| UAE | 🇦🇪 | +971 | 5X XXX XXXX |
| Bahrain | 🇧🇭 | +973 | XXXX XXXX |
| Kuwait | 🇰🇼 | +965 | XXXX XXXX |

To add more countries, edit `PhoneAuthView.swift`:

```swift
Menu {
    Button(action: { authManager.countryCode = "+966" }) {
        HStack {
            Text("🇸🇦 Saudi Arabia (+966)")
            // ...
        }
    }
    // Add more countries here
}
```

---

## 🧪 Testing

### Demo Credentials

**Phone Number**: Any valid format (e.g., 501234567)  
**OTP Code**: `123456`  
**Country**: Any from the list

### Test Scenarios

1. **First-Time User Flow**
   - See onboarding (4 slides)
   - Enter phone number
   - Receive OTP (demo: 123456)
   - Complete profile setup
   - Access main app

2. **Returning User Flow** (After first login)
   - Skip onboarding
   - Enter phone number
   - Receive OTP
   - Skip profile setup
   - Access main app immediately

3. **Error Handling**
   - Empty phone number → Error shown
   - Invalid OTP → Error shown
   - Incomplete profile → Button disabled

4. **Logout Flow**
   - Navigate to Profile → Settings
   - Tap "Logout"
   - Confirm in alert dialog
   - Return to Phone Entry screen

### Manual Testing Checklist

- [ ] Onboarding flows correctly
- [ ] Skip button works
- [ ] Country code selector works
- [ ] Phone input accepts numbers only
- [ ] OTP fields advance automatically
- [ ] Countdown timer works
- [ ] Resend button appears after 60s
- [ ] Profile validation works
- [ ] Pet selection works
- [ ] Logout clears session
- [ ] Language toggle works throughout auth
- [ ] RTL layout works in Arabic

---

## 📱 Integration Guide

### Step 1: Add Backend API

Replace demo logic in `AuthManager.swift`:

```swift
func sendOTP() {
    isLoading = true
    errorMessage = nil
    
    // Replace this with real API call
    let url = URL(string: "https://api.saayr.sa/auth/send-otp")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body = [
        "phone": "\(countryCode)\(phoneNumber)",
        "language": "en" // or "ar"
    ]
    request.httpBody = try? JSONEncoder().encode(body)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        DispatchQueue.main.async {
            self.isLoading = false
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            // Handle success
            self.authState = .otpVerification
        }
    }.resume()
}
```

### Step 2: Implement OTP Verification

```swift
func verifyOTP() {
    isLoading = true
    errorMessage = nil
    
    let url = URL(string: "https://api.saayr.sa/auth/verify-otp")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body = [
        "phone": "\(countryCode)\(phoneNumber)",
        "code": otpCode
    ]
    request.httpBody = try? JSONEncoder().encode(body)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        DispatchQueue.main.async {
            self.isLoading = false
            
            guard let data = data else {
                self.errorMessage = "Network error"
                return
            }
            
            // Parse response
            if let result = try? JSONDecoder().decode(AuthResponse.self, from: data) {
                // Save token to Keychain
                KeychainHelper.save(token: result.token)
                
                // Check if user exists
                if result.userExists {
                    self.completeAuthentication()
                } else {
                    self.authState = .profileSetup
                }
            }
        }
    }.resume()
}
```

### Step 3: Use Keychain for Secure Storage

Add `KeychainHelper.swift`:

```swift
import Security

class KeychainHelper {
    static func save(token: String, service: String = "com.saayr.app") {
        let data = token.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    static func get(service: String = "com.saayr.app") -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        
        guard let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    static func delete(service: String = "com.saayr.app") {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
```

---

## 🎨 Customization

### Change Onboarding Slides

Edit `OnboardingView.swift`:

```swift
let pages: [OnboardingPage] = [
    OnboardingPage(
        emoji: "🎮",
        title: "Your Custom Title",
        titleAr: "العنوان المخصص",
        description: "Your description",
        descriptionAr: "الوصف الخاص بك"
    ),
    // Add more pages...
]
```

### Add More Pet Types

Edit `ProfileSetupView.swift`:

```swift
enum PetType: String, CaseIterable {
    case bird = "Bird"
    case cat = "Cat"
    case lion = "Lion"  // New pet type
    
    var emoji: String {
        switch self {
        case .lion: return "🦁"
        // ...
        }
    }
}
```

### Modify OTP Length

Currently: 6 digits  
To change: Edit `OTPVerificationView.swift`

```swift
@State private var otpFields: [String] = ["", "", "", "", "", ""]  // Change array size
```

---

## 🐛 Troubleshooting

### Issue: OTP verification fails
**Solution**: Make sure you're using `123456` as the demo OTP code

### Issue: Profile setup skipped
**Solution**: Clear UserDefaults by deleting app and reinstalling

### Issue: Stuck on onboarding
**Solution**: Check `hasSeenOnboarding` in UserDefaults

### Issue: Logout doesn't work
**Solution**: Make sure AuthManager is injected as @EnvironmentObject

### Issue: Language doesn't switch
**Solution**: Check environment setup in SaayrApp.swift

---

## 📚 File Reference

**Auth Manager**: `Managers/AuthManager.swift`  
**Auth Flow Router**: `Views/Auth/AuthenticationFlow.swift`  
**Onboarding**: `Views/Auth/OnboardingView.swift`  
**Phone Entry**: `Views/Auth/PhoneAuthView.swift`  
**OTP Verification**: `Views/Auth/OTPVerificationView.swift`  
**Profile Setup**: `Views/Auth/ProfileSetupView.swift`  

---

**Last Updated**: December 2024  
**Version**: 1.0.0  
**Authentication Method**: Phone + OTP  
**Supported Regions**: Saudi Arabia, UAE, Bahrain, Kuwait
