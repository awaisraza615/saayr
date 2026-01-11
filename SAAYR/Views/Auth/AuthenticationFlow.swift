import SwiftUI

struct AuthenticationFlow: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        Group {
            switch authManager.authState {
            case .onboarding:
                OnboardingView()
            case .phoneEntry,.forgotPasscode:
                PhoneAuthView()
            case .otpVerification, .resetOtp:
                OTPVerificationView(
                    phoneNumber: authManager.phoneNumber,
                    onVerified: {
                        authManager.authState = .profileSetup
                    },
                    onBack: {
                        authManager.authState = .phoneEntry
                    }
                )
            case .profileSetup:
                ProfileSetupView()
            case .authenticated:
                EmptyView() // This shouldn't be reached
            case .pinFlow, .resetPasscode:
                PINFlowView()
            case .petName:
                PetSelectionView()
            case .login:
                PINLoginView()
            }
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.3), value: authManager.authState)
    }
}

#Preview {
    AuthenticationFlow()
        .environmentObject(AuthManager())
        .environmentObject(LanguageManager())
}
