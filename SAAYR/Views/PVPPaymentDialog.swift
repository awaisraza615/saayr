import SwiftUI
import PassKit

struct PVPPaymentDialog: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.red, Color.pink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
                
                VStack(spacing: 8) {
                    Text(languageManager.text("pvp.title"))
                        .font(.system(size: 24, weight: .bold))
                    
                    Text("Battle against another player")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                // Match Details
                VStack(spacing: 16) {
                    DetailRow(
                        icon: "dollarsign.circle.fill",
                        label: languageManager.text("pvp.entry"),
                        value: "5 SAR",
                        color: .blue
                    )
                    
                    Divider()
                    
                    DetailRow(
                        icon: "trophy.fill",
                        label: languageManager.text("pvp.winner"),
                        value: "8 SAR",
                        color: .yellow
                    )
                    
                    Divider()
                    
                    DetailRow(
                        icon: "star.fill",
                        label: "XP Reward",
                        value: "+200 XP",
                        color: .orange
                    )
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(UIColor.secondarySystemGroupedBackground))
                )
                .padding(.horizontal)
                
                // Warning
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    
                    Text("Entry fee is non-refundable")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange.opacity(0.1))
                )
                .padding(.horizontal)
                
                Spacer()
                
                // Apple Pay Button
                ApplePayButtonView {
                    handleApplePayPayment()
                }
                .frame(height: 50)
                .padding(.horizontal)
                
                Button(action: {
                    isPresented = false
                }) {
                    Text("Cancel")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.secondary)
                }
                .padding(.bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func handleApplePayPayment() {
        // Simulate payment success
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            userManager.startPVPSession()
            isPresented = false
        }
    }
}

struct DetailRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(label)
                .font(.system(size: 16))
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.primary)
        }
    }
}

// Apple Pay Button Wrapper
struct ApplePayButtonView: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "apple.logo")
                    .font(.system(size: 20))
                Text("Pay")
                    .font(.system(size: 18, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.black)
            .cornerRadius(12)
        }
    }
}

#Preview {
    PVPPaymentDialog(isPresented: .constant(true))
        .environmentObject(LanguageManager())
        .environmentObject(UserManager())
}
