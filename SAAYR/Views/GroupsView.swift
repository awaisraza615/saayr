import SwiftUI

struct GroupsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var userManager: UserManager
    @Environment(\.dismiss) var dismiss
    @State private var showCreateGroup = false
    
    let groups = [
        UserGroup(
            id: "1",
            name: "Riyadh Explorers",
            nameAr: "مستكشفو الرياض",
            memberCount: 24,
            totalXP: 12450,
            rank: 3,
            color: "#667eea"
        ),
        UserGroup(
            id: "2",
            name: "Coffee Lovers",
            nameAr: "عشاق القهوة",
            memberCount: 18,
            totalXP: 8900,
            rank: 7,
            color: "#f093fb"
        )
    ]
    
    let topGroups = [
        UserGroup(
            id: "3",
            name: "Elite Squad",
            nameAr: "الفريق النخبوي",
            memberCount: 50,
            totalXP: 45000,
            rank: 1,
            color: "#FFD700"
        ),
        UserGroup(
            id: "4",
            name: "Weekend Warriors",
            nameAr: "محاربو نهاية الأسبوع",
            memberCount: 42,
            totalXP: 38500,
            rank: 2,
            color: "#C0C0C0"
        ),
        UserGroup(
            id: "5",
            name: "Adventure Seekers",
            nameAr: "الباحثون عن المغامرة",
            memberCount: 35,
            totalXP: 29000,
            rank: 3,
            color: "#CD7F32"
        )
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    colors: [
                        Color(hex: "#667eea"),
                        Color(hex: "#764ba2")
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // My Groups Section
                        VStack(alignment: languageManager.currentLanguage == .english ? .leading : .trailing, spacing: 12) {
                            Text(languageManager.text("groups.title"))
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            ForEach(groups) { group in
                                GroupCard(group: group, isJoined: true)
                            }
                            .padding(.horizontal)
                        }
                        
                        // Create/Join Buttons
                        HStack(spacing: 12) {
                            Button(action: { showCreateGroup = true }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text(languageManager.text("groups.create"))
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    LinearGradient(
                                        colors: [Color.green, Color.teal],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                            }
                            
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "person.badge.plus.fill")
                                    Text(languageManager.text("groups.join"))
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    LinearGradient(
                                        colors: [Color.blue, Color.cyan],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Top Groups Leaderboard
                        VStack(alignment: languageManager.currentLanguage == .english ? .leading : .trailing, spacing: 12) {
                            Text("Top Groups")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            ForEach(topGroups) { group in
                                LeaderboardGroupCard(group: group)
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle(languageManager.text("groups.title"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: languageManager.currentLanguage == .english ? "chevron.left" : "chevron.right")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .sheet(isPresented: $showCreateGroup) {
            CreateGroupView(isPresented: $showCreateGroup)
        }
    }
}

struct UserGroup: Identifiable {
    let id: String
    let name: String
    let nameAr: String
    let memberCount: Int
    let totalXP: Int
    let rank: Int
    let color: String
}

struct GroupCard: View {
    let group: UserGroup
    let isJoined: Bool
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        HStack(spacing: 16) {
            // Group Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: group.color), Color(hex: group.color).opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                
                Image(systemName: "person.3.fill")
                    .font(.system(size: 26))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: languageManager.currentLanguage == .english ? .leading : .trailing, spacing: 4) {
                Text(languageManager.currentLanguage == .english ? group.name : group.nameAr)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Text("\(group.memberCount) \(languageManager.text("groups.members"))")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
                
                HStack(spacing: 8) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.yellow)
                    
                    Text("\(languageManager.text("groups.rank")) #\(group.rank)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.yellow)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(group.totalXP)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Text("XP")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.8))
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

struct LeaderboardGroupCard: View {
    let group: UserGroup
    @EnvironmentObject var languageManager: LanguageManager
    
    var medalIcon: String {
        switch group.rank {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return "\(group.rank)"
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Rank
            Text(medalIcon)
                .font(.system(size: 32))
                .frame(width: 50)
            
            // Group Info
            VStack(alignment: languageManager.currentLanguage == .english ? .leading : .trailing, spacing: 4) {
                Text(languageManager.currentLanguage == .english ? group.name : group.nameAr)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                Text("\(group.memberCount) \(languageManager.text("groups.members"))")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            // XP
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(group.totalXP)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.yellow)
                
                Text("XP")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
    }
}

struct CreateGroupView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var languageManager: LanguageManager
    @State private var groupName = ""
    @State private var groupDescription = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Group Details")) {
                    TextField("Group Name", text: $groupName)
                    TextField("Description", text: $groupDescription)
                }
            }
            .navigationTitle("Create Group")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        isPresented = false
                    }
                    .disabled(groupName.isEmpty)
                }
            }
        }
    }
}

#Preview {
    GroupsView()
        .environmentObject(LanguageManager())
        .environmentObject(UserManager())
}
