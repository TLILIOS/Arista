//
//  UserRepositoryProtocol.swift
//  Arista
//
//  Created by TLiLi Hamdi on 14/02/2025.
//

import Foundation
protocol UserRepositoryProtocol {
    func getUser() throws -> User?
}

// Extension pour fournir l'implémentation par défaut
extension UserRepository: UserRepositoryProtocol {}
