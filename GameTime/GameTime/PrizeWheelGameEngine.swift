//
//  PrizeWheelGameEngine.swift
//  GameTime
//
//  Created by Jason Sanchez on 1/13/25.
//

import Foundation

class PrizeWheelGameEngine: GameEngine {
    var activeSplits: Int = 0
    
    func startGame() -> Result<GameSession, GameError> {
        let sessionId = UUID()
        let session = GameSession(
            id: sessionId,
            startTime: Date(),
            currentMultiplier: 1.0,
            consecutiveWins: 0
        )
        sessions[sessionId] = session
        return.success(session)
    }
    
    func spin(sessionId: UUID) -> Result<SpinResult, GameError> {
        <#code#>
    }
    
    func lockIn(sessionId: UUID) -> Result<FinalPayout, GameError> {
        <#code#>
    }
    
    private var sessions: [UUID: GameSession] = [:]
    
    // MARK: random generation
    func generateRandomOutcome(probabilities: [Double]) -> Int {
        let total = probabilities.reduce(0, +)
        let randomValue = Double.random(in: 0..<total) // Use cryptographic randomness here if needed
        var cumulative = 0.0
        for (index, probability) in probabilities.enumerated() {
            cumulative += probability
            if randomValue < cumulative {
                return index
            }
        }
        return probabilities.count - 1
    }
    // MARK: SPLIT mechanics
    
    func applyMultiplier(baseMultiplier: Double) -> Double {
        let effectiveMultiplier = baseMultiplier * pow(2.0, Double(activeSplits))
        activeSplits = 0 // Reset SPLITS after application
        return effectiveMultiplier
    }
    
    // MARK: Double or Nothing
    func doubleOrNothing(currentTotal: Int) -> Result<Int, GameError> {
        let randomValue = Double.random(in: 0...1)
        if randomValue < 0.4 {
            return .success(currentTotal * 2)
        } else {
            return .success(0)
        }
    }
}
