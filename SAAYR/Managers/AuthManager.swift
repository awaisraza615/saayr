import Foundation
import SwiftUI
import Combine

enum AuthState {
    case onboarding
    case phoneEntry
    case otpVerification
    case profileSetup
    case authenticated
    case pinFlow
    case petName
}

class AuthManager: ObservableObject {
    @Published var authState: AuthState
    @Published var phoneNumber: String = ""
    @Published var countryCode: String = "+966" // Saudi Arabia default
    @Published var otpCode: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Temporary storage for profile setup
    @Published var tempFullName: String = ""
    @Published var tempEmail: String = ""
    @Published var tempPetName: String = ""
    @Published var tempPetType: String = ""
    
    init() {
        // Check if user is already authenticated
        if UserDefaults.standard.bool(forKey: "isAuthenticated") {
            self.authState = .authenticated
        } else if UserDefaults.standard.bool(forKey: "hasSeenOnboarding") {
            self.authState = .phoneEntry
        } else {
            self.authState = .onboarding
        }
    }
    
    // MARK: - Onboarding
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        withAnimation {
            authState = .phoneEntry
        }
    }
    
    // MARK: - Phone Authentication
    
    func sendOTP() {
        guard validatePhoneNumber() else {
            errorMessage = "Please enter a valid phone number"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Simulate API call to send OTP
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isLoading = false
            
            // In production, this would call your backend API
            // For demo, we'll simulate success
            withAnimation {
                self?.authState = .otpVerification
            }
            
            // For demo purposes - print OTP code (in production, this comes via SMS)
            print("📱 Demo OTP Code: 123456")
        }
    }
    
    func sendPinFlow() {
        
        isLoading = true
        errorMessage = nil
        
        // Simulate API call to send OTP
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isLoading = false
            
            // In production, this would call your backend API
            // For demo, we'll simulate success
            withAnimation {
                self?.authState = .pinFlow
            }
            
            // For demo purposes - print OTP code (in production, this comes via SMS)
            print("📱 Demo pin Code: 123456")
        }
    }
    
    func validatePhoneNumber() -> Bool {
        // Basic validation - should have at least 9 digits for Saudi numbers
        let digits = phoneNumber.filter { $0.isNumber }
        return digits.count >= 9
    }
    
    // MARK: - OTP Verification
    
    func verifyOTP() {
        guard otpCode.count == 6 else {
            errorMessage = "Please enter the 6-digit code"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Simulate API call to verify OTP
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isLoading = false
            
            // In production, verify with backend
            // For demo, accept "123456" as valid OTP
            if self?.otpCode == "123456" {
                // Check if user exists (has profile)
                let hasProfile = UserDefaults.standard.bool(forKey: "hasProfile")
                
                withAnimation {
                    if hasProfile {
                        // Existing user - go straight to app
                        self?.completeAuthentication()
                    } else {
                        // New user - need profile setup
                        self?.authState = .profileSetup
                    }
                }
            } else {
                self?.errorMessage = "Invalid code. Please try again."
            }
        }
    }
    
    func resendOTP() {
        otpCode = ""
        errorMessage = nil
        sendOTP()
    }
    
    // MARK: - Profile Setup
    
    func completeProfileSetup() {
        guard validateProfileData() else {
            errorMessage = "Please fill in all fields"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Simulate API call to create profile
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isLoading = false
            
            // Save profile data
            UserDefaults.standard.set(self?.tempFullName, forKey: "fullName")
            UserDefaults.standard.set(self?.tempEmail, forKey: "email")
//            UserDefaults.standard.set(self?.tempPetName, forKey: "petName")
//            UserDefaults.standard.set(self?.tempPetType, forKey: "petType")
            UserDefaults.standard.set(true, forKey: "hasProfile")
            
            // Complete authentication
            self?.sendPinFlow()
        }
    }
    
    func completeSetup() {
        
        
        isLoading = true
        errorMessage = nil
        
        // Simulate API call to create profile
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isLoading = false
            
          
           UserDefaults.standard.set(self?.tempPetName, forKey: "petName")

            // Complete authentication
            self?.completeAuthentication()
        }
    }
    
    func validateProfileData() -> Bool {
        return !tempFullName.isEmpty &&
               !tempEmail.isEmpty &&
               tempEmail.contains("@")
//                &&!tempPetName.isEmpty &&
//               !tempPetType.isEmpty
    }
    
    // MARK: - Complete Authentication
    
    func completeAuthentication() {
        UserDefaults.standard.set(true, forKey: "isAuthenticated")
        UserDefaults.standard.set("\(countryCode)\(phoneNumber)", forKey: "phoneNumber")
        
        withAnimation {
            authState = .authenticated
        }
    }
    
    // MARK: - Logout
    
    func logout() {
        UserDefaults.standard.set(false, forKey: "isAuthenticated")
        
        // Clear sensitive data
        phoneNumber = ""
        otpCode = ""
        tempFullName = ""
        tempEmail = ""
        tempPetName = ""
        tempPetType = ""
        
        withAnimation {
            authState = .phoneEntry
        }
    }
    
    // MARK: - Edit Phone Number
    
    func editPhoneNumber() {
        otpCode = ""
        errorMessage = nil
        withAnimation {
            authState = .phoneEntry
        }
    }
}
