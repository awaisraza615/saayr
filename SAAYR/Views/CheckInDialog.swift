import SwiftUI

struct CheckInDialog: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var userManager: UserManager
    @State private var selectedLocation = "Kingdom Centre"
    
    let locations = [
        "Kingdom Centre",
        "Al Faisaliah Tower",
        "Riyadh Park",
        "Granada Center",
        "Panorama Mall",
        "Sahara Mall"
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.green, Color.teal],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "location.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
                
                VStack(spacing: 8) {
                    Text(languageManager.text("home.checkIn"))
                        .font(.system(size: 24, weight: .bold))
                    
                    Text("Select a location to check in")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                // Location Picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Location")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    Picker("Location", selection: $selectedLocation) {
                        ForEach(locations, id: \.self) { location in
                            Text(location).tag(location)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 150)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(UIColor.secondarySystemGroupedBackground))
                )
                .padding(.horizontal)
                
                // XP Reward
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    
                    Text("+50 XP")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.orange)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange.opacity(0.1))
                )
                .padding(.horizontal)
                
                Spacer()
                
                // Check In Button
                Button(action: {
                    userManager.checkIn(at: selectedLocation)
                    isPresented = false
                }) {
                    Text(languageManager.text("home.checkIn"))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color.green, Color.teal],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

#Preview {
    CheckInDialog(isPresented: .constant(true))
        .environmentObject(LanguageManager())
        .environmentObject(UserManager())
}
