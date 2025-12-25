//
//  PINFlowView.swift
//  SAAYR
//
//  Created by Awais Raza on 25/12/2025.
//


import SwiftUI

struct PINFlowView: View {
    @State private var firstPin: String = ""
    @State private var confirmPin: String = ""
    @State private var showingConfirmation: Bool = false
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
                
                    HStack {
                        Button(action: {
                            showingConfirmation = false
                            confirmPin = ""
                            showError = false
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color(hex: "#059669"))
                                .font(.system(size: 20, weight: .bold))
                        }
                        Spacer()
                    }.opacity(showingConfirmation ? 1 : 0)
                    .padding(.horizontal, 24)
                
                
                
                Spacer().frame(height: 16)
                
                // PIN Entry
                PINEntryView(
                    title: showingConfirmation ? "Confirm your PIN" : "Create your PIN",
                    subtitle: showingConfirmation ? "Enter your PIN again to confirm" : "Create a 4-digit PIN to secure your account",
                    pin: showingConfirmation ? $confirmPin : $firstPin,
                    showError: $showError,
                    gradientColors: gradientColors,
                    onComplete: {
                        if showingConfirmation {
                            showSuccess = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                authManager.authState = .petName
                            }
                        } else {
                            // Auto-switch to confirmation
                            showingConfirmation = true
                        }
                    }
                )
                .padding(24)
                
                Spacer()
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


// MARK: - Reusable PIN Entry View
struct PINEntryView: View {
    let title: String
    let subtitle: String
    @Binding var pin: String
    @Binding var showError: Bool
    let gradientColors: [Color]
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            // Icon
            ZStack {
                Circle()
                    .fill(RadialGradient(colors: gradientColors, center: .center, startRadius: 0, endRadius: 60))
                    .frame(width: 120, height: 120)
                Text("🔐").font(.system(size: 64))
            }
            
            VStack(spacing: 16) {
                Text(title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            // PIN Dots
            HStack(spacing: 16) {
                ForEach(0..<4) { index in
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(showError ? Color.red : (index < pin.count ? Color(hex: "#10B981") : Color.gray), lineWidth: 2)
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.9)))
                            .frame(width: 64, height: 64)
                        if index < pin.count {
                            Circle().fill(showError ? Color.red : Color(hex: "#10B981")).frame(width: 16, height: 16)
                        }
                    }
                }
            }
            
            if showError {
                Text("PINs don't match. Try again.")
                    .foregroundColor(.red)
                    .font(.system(size: 14, weight: .medium))
            }
            
            // Number Pad
            PINNumberPad(
                onNumberClick: { number in
                    if pin.count < 4 {
                        pin += number
                        showError = false
                        if pin.count == 4 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                onComplete()
                            }
                        }
                    }
                },
                onBackspaceClick: {
                    if !pin.isEmpty { pin.removeLast() }
                    showError = false
                }
            )
        }
    }
}


// MARK: - Number Pad
struct PINNumberPad: View {
    let onNumberClick: (String) -> Void
    let onBackspaceClick: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            let rows = [["1","2","3"], ["4","5","6"], ["7","8","9"]]
            
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { num in
                        Button(action: { onNumberClick(num) }) {
                            Text(num)
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, minHeight: 70)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(16)
                                .overlay(RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color(hex: "#10B981").opacity(0.3), lineWidth: 1))
                        }
                    }
                }
            }
            
            HStack(spacing: 12) {
                Spacer()
                
                Button(action: { onNumberClick("0") }) {
                    Text("0")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: "#10B981").opacity(0.3), lineWidth: 1))
                }
                
                Button(action: onBackspaceClick) {
                    Image(systemName: "delete.left")
                        .foregroundColor(Color(hex: "#059669"))
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .background(Color(hex: "#DCFCE7"))
                        .cornerRadius(16)
                }
            }
        }
        .padding(.horizontal, 24)
    }
}



// MARK: - Confetti Particles
struct PINConfettiParticle: View {
    let index: Int
    @State private var yOffset: CGFloat = 0
    
    var body: some View {
        let emoji = ["🎉","✨","🎊","⭐","💫","🌟"][index % 6]
        Text(emoji)
            .font(.system(size: 24))
            .opacity(0.8)
            .offset(x: CGFloat.random(in: -200...200), y: yOffset)
            .onAppear {
                withAnimation(Animation.linear(duration: Double(2 + index/10)).repeatForever(autoreverses: false)) {
                    yOffset = 600
                }
            }
    }
}


// MARK: - Floating Particles
struct FloatingParticlePIN: View {
    let emoji: String
    let index: Int
    @State private var animate = false
    
    var body: some View {
        let positions: [CGPoint] = [CGPoint(x: 0.15, y: 0.2), CGPoint(x: 0.85, y: 0.25),
                                    CGPoint(x: 0.1, y: 0.6), CGPoint(x: 0.9, y: 0.65)]
        let pos = positions[index % positions.count]
        
        Text(emoji)
            .font(.system(size: 32))
            .opacity(0.4)
            .position(x: UIScreen.main.bounds.width * pos.x + (animate ? 15 : -15),
                      y: UIScreen.main.bounds.height * pos.y + (animate ? -30 : 0))
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                    animate.toggle()
                }
            }
    }
}

#Preview {
    PINFlowView(
    )
    .environmentObject(AuthManager())
    .environmentObject(LanguageManager())
}
