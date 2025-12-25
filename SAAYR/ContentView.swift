import SwiftUI

struct ContentView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var userManager: UserManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label(languageManager.text("nav.home"), systemImage: "house.fill")
                }
                .tag(0)
            
            ChallengesView()
                .tabItem {
                    Label(languageManager.text("nav.challenges"), systemImage: "target")
                }
                .tag(1)
            
            MapView()
                .tabItem {
                    Label(languageManager.text("nav.map"), systemImage: "map.fill")
                }
                .tag(2)
            
            RewardsView()
                .tabItem {
                    Label(languageManager.text("nav.rewards"), systemImage: "gift.fill")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Label(languageManager.text("nav.profile"), systemImage: "person.fill")
                }
                .tag(4)
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
        .environmentObject(LanguageManager())
        .environmentObject(UserManager())
}
