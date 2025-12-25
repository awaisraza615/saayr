import SwiftUI

struct RewardsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var userManager: UserManager
    
    @State private var rewards: [Reward] = getDemoRewards()
    @State private var showRedeemDialog = false
    @State private var selectedReward: Reward?
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(hex: "#F0F9FF"), Color.white, Color(hex: "#FFF7ED")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(languageManager.text("rewards.title"))
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text(languageManager.text("rewards.subtitle"))
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        
                        // XP Balance Card
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.blue)
                            .frame(height: 100)
                            .overlay(
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(languageManager.text("rewards.yourXP"))
                                            .foregroundColor(.white.opacity(0.8))
                                            .font(.system(size: 14))
                                        
                                        Text("\(userManager.userData.totalXP)")
                                            .font(.system(size: 32, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .foregroundColor(.white)
                                }
                                .padding()
                            )
                    }
                    .padding(.horizontal)
                    .padding(.top, 24)
                    
                    // Rewards List
                    VStack(spacing: 16) {
                        ForEach(rewards) { reward in
                            RewardCard(reward: reward) { selected in
                                selectedReward = selected
                                showRedeemDialog = true
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .alert(isPresented: $showRedeemDialog) {
            guard let reward = selectedReward else {
                return Alert(title: Text("Error"))
            }
            
            return Alert(
                title: Text("Redeem Reward"),
                message: Text("Are you sure you want to redeem \(reward.title) for \(reward.xpRequired) XP?"),
                primaryButton: .default(Text("Redeem"), action: {
                    if let index = rewards.firstIndex(where: { $0.id == reward.id }) {
                        rewards[index].isRedeemed = true
                        userManager.userData.totalXP -= reward.xpRequired
                    }
                }),
                secondaryButton: .cancel()
            )
        }
    }
}

// MARK: Reward Card
struct RewardCard: View {
    var reward: Reward
    var onRedeem: (Reward) -> Void
    
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var languageManager: LanguageManager
    
    var canAfford: Bool {
        //userManager.userData.totalXP >= reward.xpRequired
        3600 >= reward.xpRequired
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                // Reward Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: reward.imageColor))
                        .frame(width: 60, height: 60)
                    
                    Text(reward.imageEmoji)
                        .font(.system(size: 28))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(reward.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(reward.isRedeemed ? .gray : .black)
                    
                    Text(reward.partner)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            HStack {
                Text("\(reward.xpRequired) XP")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(canAfford ? .blue : .gray)
                
                Spacer()
                
                Button(action: {
                    onRedeem(reward)
                }) {
                    Text(canAfford ? "Redeem" : "Locked")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(
                                   ZStack {
                                       if canAfford {
                                           LinearGradient(colors: [.green, .teal], startPoint: .leading, endPoint: .trailing)
                                       } else {
                                           Color.gray
                                       }
                                   }
                               )
                        .cornerRadius(12)
                }
                .disabled(!canAfford || reward.isRedeemed)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.15))
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                )
        )
    }
}

// MARK: Reward Model
struct Reward: Identifiable {
    let id: String
    let title: String
    let titleAr: String
    let description: String
    let descriptionAr: String
    let xpRequired: Int
    let partner: String
    let value: String
    let imageEmoji: String
    let imageColor: String
    var isRedeemed: Bool = false
}

// MARK: Dummy Data
func getDemoRewards() -> [Reward] {
    return [
        Reward(
            id: "1",
            title: "Amazon Voucher",
            titleAr: "بطاقة أمازون",
            description: "25 SAR Amazon gift card",
            descriptionAr: "25 ريال بطاقة هدايا أمازون",
            xpRequired: 2500,
            partner: "Amazon",
            value: "25 SAR",
            imageEmoji: "📦",
            imageColor: "#FF9900"
        ),
        Reward(
            id: "2",
            title: "Starbucks Voucher",
            titleAr: "قسيمة ستاربكس",
            description: "Free grande beverage",
            descriptionAr: "مشروب مجاني",
            xpRequired: 3000,
            partner: "Starbucks",
            value: "1 Drink",
            imageEmoji: "☕",
            imageColor: "#00704A"
        ),
        Reward(
            id: "3",
            title: "Cinema Ticket",
            titleAr: "تذكرة سينما",
            description: "VOX Cinemas ticket",
            descriptionAr: "تذكرة لمهرجان VOX",
            xpRequired: 5000,
            partner: "VOX Cinemas",
            value: "1 Ticket",
            imageEmoji: "🎬",
            imageColor: "#E91E63"
        ),
        Reward(
            id: "4",
            title: "McDonald's Meal",
            titleAr: "وجبة ماكدونالدز",
            description: "Buy 1 Get 1 Free",
            descriptionAr: "اشترِ واحدة واحصل على الأخرى مجانًا",
            xpRequired: 3500,
            partner: "McDonald's",
            value: "BOGO",
            imageEmoji: "🍔",
            imageColor: "#FFC107"
        ),
        Reward(
            id: "5",
            title: "Noon Voucher",
            titleAr: "قسيمة نون",
            description: "75 SAR Noon credit",
            descriptionAr: "رصيد 75 ريال نون",
            xpRequired: 7500,
            partner: "Noon",
            value: "75 SAR",
            imageEmoji: "🛍️",
            imageColor: "#2196F3"
        ),
        Reward(
            id: "6",
            title: "Jarir Bookstore",
            titleAr: "مكتبة جرير",
            description: "100 SAR voucher",
            descriptionAr: "قسيمة 100 ريال",
            xpRequired: 10000,
            partner: "Jarir",
            value: "100 SAR",
            imageEmoji: "📚",
            imageColor: "#9C27B0"
        ),
        Reward(
            id: "7",
            title: "Extra Stores",
            titleAr: "متاجر اكسترا",
            description: "100 SAR voucher",
            descriptionAr: "قسيمة 100 ريال",
            xpRequired: 10000,
            partner: "Extra",
            value: "100 SAR",
            imageEmoji: "🏪",
            imageColor: "#FF5722"
        )
    ]
}


#Preview {
    RewardsView()
        .environmentObject(LanguageManager())
        .environmentObject(UserManager())
}
