//
//  TransactionManager.swift
//  GameTime
//
//  Created by Jason Sanchez on 1/13/25.
//

import Foundation

class TransactionManager: TransactionEngine {
    func rollback(transactionId: UUID) -> Result<Void, TransactionError> {
        <#code#>
    }
    
    private var transactions: [UUID: Transaction] = [:]
    private let queue = DispatchQueue(label: "transaction.queue")
    
    func processTransaction(sessionId: UUID, amount: Int, type: TransactionType) -> Result<Transaction, TransactionError> {
        queue.sync {
            let transaction = Transaction(
                id: UUID(),
                sessionId: sessionId,
                amount: amount,
                type: type,
                timestamp: Date()
            )
            transactions[transaction.id] = transaction
            return .success(transaction)
        }
    }
}
