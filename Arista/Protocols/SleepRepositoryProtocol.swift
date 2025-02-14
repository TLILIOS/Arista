//
//  SleepRepositoryProtocol.swift
//  Arista
//
//  Created by TLiLi Hamdi on 14/02/2025.
//

import Foundation

protocol SleepRepositoryProtocol {
    func getSleepSessions() throws -> [Sleep]
}

// Extension pour fournir l'implémentation par défaut
extension SleepRepository: SleepRepositoryProtocol {}
