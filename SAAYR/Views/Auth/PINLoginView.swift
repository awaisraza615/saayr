//
//  PINFlowView 2.swift
//  SAAYR
//
//  Created by Awais Raza on 10/01/2026.
//


//
//  PINFlowView.swift
//  SAAYR
//
//  Created by Awais Raza on 25/12/2025.
//


import SwiftUI

struct PINLoginView: View {
    @State private var firstPin: String = ""
    @State private var showError: Bool = false
    @State private var showSuccess: Bool = false
    
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var languageManager: LanguageManager
    
    let gradientColors: [Color] = [Color(hex: "#10B981"), Color(hex: "#059669"), Color(hex: "#14B8A6")]
    let particles = ["🔐", "🔒", "✨", "⭐"]
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(colors: [Color(hex: "#ECFDF5"), Color(hex: "#D1FAE5"), Color(hex: "#CCFBF1")],
                           startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            // Floating particles
            ForEach(particles.indices, id: \.self) { index in
                FloatingParticlePIN(emoji: particles[index], index: index)
            }
            
            VStack {
                // Back button for confirmation
                
                
                
                
                Spacer().frame(height: 16)
                
                // PIN Entry
                PINEntryView(
                    title:"Enter your PIN",
                    subtitle: "Enter a 4-digit PIN to login to your account",
                    pin: $firstPin,
                    showError: $showError,
                    gradientColors: gradientColors,
                    onComplete: {
                        
                        authManager.tempPasscode = $firstPin.wrappedValue
                        authManager.completeLogin {
                            // Navigate to pet name after short delay to show success
                            showSuccess = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                withAnimation {
                                    authManager.completeAuthentication()
                                }
                            }
                        }
                        
                    }
                )
                .padding(24)
                .onChange(of: authManager.errorMessage) { newValue in
                    if newValue != nil {
                        withAnimation {
                            showError = true
                        }
                    }
                }
                Spacer()
                
                Button(
                    action: {
                        withAnimation {
                            authManager.authState = .forgotPasscode
                        }
                    },
                    label: {
                        Text("Forgot your PIN")
                            .foregroundColor(.green)
                            .padding()
                    }
                )
            }
            
            // Success overlay
            if showSuccess {
                ZStack {
                    Color.black.opacity(0.5).ignoresSafeArea()
                    ZStack {
                        ForEach(0..<20, id: \.self) { i in
                            PINConfettiParticle(index: i)
                        }
                        Circle()
                            .fill(Color.white)
                            .frame(width: 120, height: 120)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.system(size: 64))
                                    .foregroundColor(Color(hex: "#10B981"))
                            )
                    }
                }
            }
        }
    }
}

#Preview {
    PINLoginView(
    )
    .environmentObject(AuthManager())
    .environmentObject(LanguageManager())
}
