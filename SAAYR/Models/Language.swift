import Foundation
import SwiftUI
import Combine

enum Language: String, Codable {
    case english = "en"
    case arabic = "ar"
}

class LanguageManager: ObservableObject {
    @Published var currentLanguage: Language {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "selectedLanguage")
        }
    }
    
    init() {
        let savedLang = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
        self.currentLanguage = Language(rawValue: savedLang) ?? .english
    }
    
    func toggleLanguage() {
        withAnimation {
            currentLanguage = currentLanguage == .english ? .arabic : .english
        }
    }
    
    func text(_ key: String) -> String {
        return currentLanguage == .english ? Translations.english[key] ?? key : Translations.arabic[key] ?? key
    }
}

struct Translations {
    static let english: [String: String] = [
        // Navigation
        "nav.home": "Home",
        "nav.challenges": "Challenges",
        "nav.map": "Map",
        "nav.rewards": "Rewards",
        "nav.profile": "Profile",
        
        // Home Page
        "home.greeting": "Hey there! 👋",
        "home.xp": "XP",
        "home.points": "Points",
        "home.level": "Level",
        "home.streak": "Day Streak",
        "home.checkIn": "Check In",
        "home.pvp": "Battle Arena",
        "home.challenges": "Challenges",
        "home.learderboard": "Leaderboard",
        
        // Profile
        "profile.myGroups": "My Groups",
        "profile.support": "Support",
        "profile.settings": "Settings",
        "profile.stats": "Stats",
        "profile.totalXP": "Total XP",
        "profile.totalPoints": "Total Points",
        "profile.totalSpent": "Total Spent",
        "profile.rewardsClaimed": "Rewards Claimed",
        "profile.pvpWins": "PVP Wins",
        "profile.petStage": "Pet Stage",
        
        // Settings
        "settings.title": "Settings",
        "settings.general": "General",
        "settings.language": "Language",
        "settings.privacy": "Privacy & Security",
        "settings.privacyPolicy": "Privacy Policy",
        "settings.changePassword": "Change Password",
        "settings.about": "About",
        "settings.aboutSaayr": "About Saayr",
        "settings.version": "Version",
        "settings.logout": "Logout",
        "settings.logoutConfirm": "Are you sure you want to logout?",
        
        // Challenges
        "challenges.title": "Challenges",
        "challenges.subtite": "Complete challenges to earn XP and rewards",
        "challenges.daily": "Daily",
        "challenges.weekly": "Weekly",
        "challenges.special": "Special",
        "challenges.completed": "Completed",
        "challenges.claim": "Claim",
        "challenges.progress": "Progress",
        
        // Rewards
        "rewards.title": "Rewards",
        "rewards.yourXP": "Your XP",
        "rewards.redeem": "Redeem",
        "rewards.xpRequired": "XP Required",
        
        // Support
        "support.title": "Support",
        "support.helpCenter": "Help Center",
        "support.contactUs": "Contact Us",
        "support.faq": "Frequently Asked Questions",
        
        // Groups
        "groups.title": "My Groups",
        "groups.create": "Create Group",
        "groups.join": "Join Group",
        "groups.members": "members",
        "groups.rank": "Rank",
        
        // Map
        "map.title": "Map",
        "map.nearbyLocations": "Nearby Locations",
        "map.checkIn": "Check In",
        
        // PVP
        "pvp.title": "Battle Arena",
        "pvp.findOpponent": "Find Opponent",
        "pvp.entry": "Entry Fee: 5 SAR",
        "pvp.winner": "Winner Takes",
        "pvp.pay": "Pay with Apple Pay",
        
        // Common
        "common.back": "Back",
        "common.save": "Save",
        "common.cancel": "Cancel",
        "common.done": "Done",
        "common.loading": "Loading...",
        "common.confirm": "Confirm",
    ]
    
    static let arabic: [String: String] = [
        // Navigation
        "nav.home": "الرئيسية",
        "nav.challenges": "التحديات",
        "nav.map": "الخريطة",
        "nav.rewards": "المكافآت",
        "nav.profile": "الملف الشخصي",
        
        // Home Page
        "home.greeting": "!مرحباً 👋",
        "home.xp": "نقاط الخبرة",
        "home.points": "النقاط",
        "home.level": "المستوى",
        "home.streak": "سلسلة الأيام",
        "home.checkIn": "تسجيل الحضور",
        "home.pvp": "ساحة المعركة",
        "home.challenges": "التحديات",
        "home.learderboard": "المتصدرين",
        
        // Profile
        "profile.myGroups": "مجموعاتي",
        "profile.support": "الدعم",
        "profile.settings": "الإعدادات",
        "profile.stats": "الإحصائيات",
        "profile.totalXP": "مجموع نقاط الخبرة",
        "profile.totalPoints": "مجموع النقاط",
        "profile.totalSpent": "إجمالي الإنفاق",
        "profile.rewardsClaimed": "المكافآت المطالب بها",
        "profile.pvpWins": "انتصارات PVP",
        "profile.petStage": "مرحلة الحيوان الأليف",
        
        // Settings
        "settings.title": "الإعدادات",
        "settings.general": "عام",
        "settings.language": "اللغة",
        "settings.privacy": "الخصوصية والأمان",
        "settings.privacyPolicy": "سياسة الخصوصية",
        "settings.changePassword": "تغيير كلمة المرور",
        "settings.about": "حول",
        "settings.aboutSaayr": "حول سيّار",
        "settings.version": "الإصدار",
        "settings.logout": "تسجيل الخروج",
        "settings.logoutConfirm": "هل أنت متأكد من تسجيل الخروج؟",
        
        // Challenges
        "challenges.title": "التحديات",
        "challenges.daily": "يومي",
        "challenges.weekly": "أسبوعي",
        "challenges.special": "خاص",
        "challenges.completed": "مكتمل",
        "challenges.claim": "استلام",
        "challenges.progress": "التقدم",
        
        // Rewards
        "rewards.title": "المكافآت",
        "rewards.yourXP": "نقاط الخبرة الخاصة بك",
        "rewards.redeem": "استبدال",
        "rewards.xpRequired": "نقاط الخبرة المطلوبة",
        
        // Support
        "support.title": "الدعم",
        "support.helpCenter": "مركز المساعدة",
        "support.contactUs": "اتصل بنا",
        "support.faq": "الأسئلة الشائعة",
        
        // Groups
        "groups.title": "مجموعاتي",
        "groups.create": "إنشاء مجموعة",
        "groups.join": "انضم إلى مجموعة",
        "groups.members": "أعضاء",
        "groups.rank": "الترتيب",
        
        // Map
        "map.title": "الخريطة",
        "map.nearbyLocations": "المواقع القريبة",
        "map.checkIn": "تسجيل الحضور",
        
        // PVP
        "pvp.title": "ساحة المعركة",
        "pvp.findOpponent": "ابحث عن خصم",
        "pvp.entry": "رسوم الدخول: 5 ريال",
        "pvp.winner": "الفائز يأخذ",
        "pvp.pay": "الدفع بواسطة Apple Pay",
        
        // Common
        "common.back": "رجوع",
        "common.save": "حفظ",
        "common.cancel": "إلغاء",
        "common.done": "تم",
        "common.loading": "...جارٍ التحميل",
        "common.confirm": "تأكيد",
    ]
}
