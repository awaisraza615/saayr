import SwiftUI

struct ContentView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var userManager: UserManager
    /// Owned by the router rather than local state, so a screen presented over
    /// the tab bar can switch tabs on dismiss.
    @EnvironmentObject var router: AppRouter
    /// A tapped invite link lands here first — Groups lives behind the profile
    /// tab, so the tab has to move before the cover can open.
    @EnvironmentObject var invites: InviteLinkCoordinator
    @State private var showPVPPayment = false

    var body: some View {
        VStack(spacing: 0) {
            if userManager.activeMatchStatus {
                ActivePVPBanner {
                    showPVPPayment = true
                }
                .background(Color(.systemBackground))
            }

            TabView(selection: $router.selectedTab) {
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
        .fullScreenCover(isPresented: $showPVPPayment) {
            ActiveMatchView(isPresented: $showPVPPayment)
        }
        // Checked on appear as well as on change: a link that cold-launches the
        // app can redeem before this view is in the hierarchy at all.
        .onAppear { routeToInvitedGroup() }
        .onChange(of: invites.pendingGroup?.id) { _ in routeToInvitedGroup() }
        .alert(
            inviteCopy.inviteLinkTitle,
            isPresented: Binding(
                get: { invites.failure != nil },
                set: { if !$0 { invites.clearFailure() } }
            )
        ) {
            Button(inviteCopy.inviteLinkOK, role: .cancel) { invites.clearFailure() }
        } message: {
            Text(invites.failure ?? "")
        }
    }

    private var inviteCopy: GroupsCopy {
        GroupsCopy(isEnglish: languageManager.currentLanguage == .english)
    }

    /// A dead link says so wherever the player is; a live one only needs the
    /// tab moved — Profile picks it up from there.
    private func routeToInvitedGroup() {
        guard invites.pendingGroup != nil else { return }
        router.show(.profile)
    }

    private func safeAreaTop() -> CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.top ?? 0
    }
}

#Preview {
    ContentView()
        .environmentObject(LanguageManager())
        .environmentObject(UserManager())
        .environmentObject(AppRouter())
        .environmentObject(InviteLinkCoordinator())
}
