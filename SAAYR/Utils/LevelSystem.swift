import Foundation
import SwiftUI

struct LevelSystem {
    // XP required for each level
    static let xpPerLevel = 1000
    
    // XP Rewards
    static let checkInRegular = 50
    static let checkInSponsored = 100
    static let challengeDaily = 100
    static let challengeWeekly = 500
    static let pvpWin = 200
    
    // Calculate level from total XP
    static func getLevelFromXP(_ xp: Int) -> Int {
        return max(1, (xp / xpPerLevel) + 1)
    }
    
    // Calculate points from XP (100 XP = 1 Point)
    static func calculatePointsFromXP(_ xp: Int) -> Int {
        return xp / 100
    }
    
    // Calculate XP from spending (1 SAR = 1 XP, with multipliers)
    static func calculateXPFromSpending(_ amount: Double, multiplier: Int = 1) -> Int {
        return Int(amount) * multiplier
    }
    
    // Get XP progress to next level
    static func getXPProgressToNextLevel(_ totalXP: Int) -> XPProgress {
        let currentLevel = getLevelFromXP(totalXP)
        let xpForCurrentLevel = (currentLevel - 1) * xpPerLevel
        let xpIntoCurrentLevel = totalXP - xpForCurrentLevel
        let progressPercentage = Double(xpIntoCurrentLevel) / Double(xpPerLevel)
        
        return XPProgress(
            currentLevelXP: xpIntoCurrentLevel,
            nextLevelXP: xpPerLevel,
            progressPercentage: min(1.0, progressPercentage)
        )
    }
    
    // Get pet stage based on level
    static func getPetStage(_ level: Int) -> PetStage {
        switch level {
        case 1...5:
            return .egg
        case 6...15:
            return .hatchling
        case 16...30:
            return .juvenile
        case 31...50:
            return .adult
        default:
            return .legendary
        }
    }
    
    // Get evolution reward points when evolving
    static func getEvolutionRewardPoints(_ newStage: PetStage) -> Int {
        switch newStage {
        case .egg:
            return 0
        case .hatchling:
            return 50
        case .juvenile:
            return 100
        case .adult:
            return 200
        case .legendary:
            return 500
        }
    }
    
    // Level ranges for each stage
    static func getLevelRangeForStage(_ stage: PetStage) -> String {
        switch stage {
        case .egg:
            return "1-5"
        case .hatchling:
            return "6-15"
        case .juvenile:
            return "16-30"
        case .adult:
            return "31-50"
        case .legendary:
            return "51+"
        }
    }
    
    // MARK: - Gradient Colors for each stage
    struct StageGradient {
        let start: Color
        let end: Color
    }
    
    static func getStageGradientColors(_ stage: PetStage) -> StageGradient {
        switch stage {
        case .egg:
            return StageGradient(start: Color(hex: "#EC4899"), end: Color(hex: "#F97316"))
        case .hatchling:
            return StageGradient(start: Color(hex: "#F97316"), end: Color(hex: "#A855F7"))
        case .juvenile:
            return StageGradient(start: Color(hex: "#3B82F6"), end: Color(hex: "#06B6D4"))
        case .adult:
            return StageGradient(start: Color(hex: "#10B981"), end: Color(hex: "#14B8A6"))
        case .legendary:
            return StageGradient(start: Color(hex: "#FBBF24"), end: Color(hex: "#F59E0B"))
        }
    }
}
