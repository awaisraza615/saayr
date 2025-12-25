import Foundation
import SwiftUI
import Combine

class UserManager: ObservableObject {
    @Published var userData: UserData
    @Published var activePVPSession = false
    
    init() {
        // Initialize with demo data
        self.userData = UserData(
            fullName: "Ahmed Al-Rashid",
            email: "ahmed@example.com",
            phoneNumber: "+966501234567",
            petName: "Aziz",
            petType: "Bird",
            totalXP: 289,
            checkInStreak: 3,
            checkInLogs: [],
            transactions: [
                Transaction(
                    id: "1",
                    merchantName: "Dose Café",
                    amount: 45.50,
                    currency: "SAR",
                    category: "cafe",
                    timestamp: Date().addingTimeInterval(-86400),
                    xpAwarded: 91,
                    pointsAwarded: 0,
                    isPartner: true,
                    multiplier: 2
                ),
                Transaction(
                    id: "2",
                    merchantName: "Burger King",
                    amount: 67.00,
                    currency: "SAR",
                    category: "restaurant",
                    timestamp: Date().addingTimeInterval(-172800),
                    xpAwarded: 134,
                    pointsAwarded: 1,
                    isPartner: true,
                    multiplier: 2
                ),
                Transaction(
                    id: "3",
                    merchantName: "Starbucks",
                    amount: 32.00,
                    currency: "SAR",
                    category: "cafe",
                    timestamp: Date().addingTimeInterval(-259200),
                    xpAwarded: 64,
                    pointsAwarded: 0,
                    isPartner: true,
                    multiplier: 2
                )
            ],
            achievements: [],
            groups: []
        )
    }
    
    // Add XP and handle level ups
    func addXP(_ amount: Int, reason: String) {
        let oldLevel = userData.level
        userData.totalXP += amount
        let newLevel = userData.level
        
        if newLevel > oldLevel {
            // Level up!
            let oldStage = LevelSystem.getPetStage(oldLevel)
            let newStage = userData.petStage
            
            if oldStage != newStage {
                // Evolution!
                let rewardPoints = LevelSystem.getEvolutionRewardPoints(newStage)
                userData.totalXP += (rewardPoints * 100) // Convert points to XP
            }
        }
    }
    
    // Add transaction
    func addTransaction(merchantName: String, amount: Double, category: String, isPartner: Bool, multiplier: Int = 1) {
        let xpAwarded = LevelSystem.calculateXPFromSpending(amount, multiplier: multiplier)
        let oldPoints = userData.points
        
        let transaction = Transaction(
            id: UUID().uuidString,
            merchantName: merchantName,
            amount: amount,
            currency: "SAR",
            category: category,
            timestamp: Date(),
            xpAwarded: xpAwarded,
            pointsAwarded: 0,
            isPartner: isPartner,
            multiplier: multiplier
        )
        
        userData.transactions.insert(transaction, at: 0)
        addXP(xpAwarded, reason: "Transaction at \(merchantName)")
        
        let newPoints = userData.points
        let pointsAwarded = newPoints - oldPoints
        
        if pointsAwarded > 0 {
            // Update transaction with points awarded
            if let index = userData.transactions.firstIndex(where: { $0.id == transaction.id }) {
                var updatedTransaction = userData.transactions[index]
                userData.transactions[index] = Transaction(
                    id: updatedTransaction.id,
                    merchantName: updatedTransaction.merchantName,
                    amount: updatedTransaction.amount,
                    currency: updatedTransaction.currency,
                    category: updatedTransaction.category,
                    timestamp: updatedTransaction.timestamp,
                    xpAwarded: updatedTransaction.xpAwarded,
                    pointsAwarded: pointsAwarded,
                    isPartner: updatedTransaction.isPartner,
                    multiplier: updatedTransaction.multiplier
                )
            }
        }
    }
    
    // Check in at location
    func checkIn(at location: String) {
        let xpAwarded = LevelSystem.checkInRegular
        
        let checkIn = CheckInLog(
            id: UUID().uuidString,
            location: location,
            timestamp: Date(),
            xpAwarded: xpAwarded
        )
        
        userData.checkInLogs.insert(checkIn, at: 0)
        userData.checkInStreak += 1
        addXP(xpAwarded, reason: "Check-in at \(location)")
    }
    
    // Start PVP session
    func startPVPSession() {
        activePVPSession = true
    }
    
    // Complete PVP session
    func completePVPSession(won: Bool) {
        activePVPSession = false
        if won {
            addXP(LevelSystem.pvpWin, reason: "PVP Victory")
        }
    }
}

extension UserData {
    var checkInCount: Int {
        checkInLogs.count
    }
}

extension UserManager {
    var stageColor: Color {
        let stage = LevelSystem.getPetStage(userData.level)
        let colors = LevelSystem.getStageGradientColors(stage)
        return colors.start // Use the starting color of the gradient as a solid color
    }
}
