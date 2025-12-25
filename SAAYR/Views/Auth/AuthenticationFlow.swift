import SwiftUI

struct AuthenticationFlow: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        Group {
            switch authManager.authState {
            case .onboarding:
                OnboardingView()
            case .phoneEntry:
                PhoneAuthView()
            case .otpVerification:
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
            case .pinFlow:
                PINFlowView()
            case .petName:
                PetSelectionView()
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
