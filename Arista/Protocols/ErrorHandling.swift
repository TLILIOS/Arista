//
//  ErrorHandling.swift
//  Arista
//
//  Created by TLiLi Hamdi on 07/02/2025.
//

import Foundation
import CoreData

// MARK: - Protocol pour la gestion des erreurs
protocol ErrorHandling: AnyObject {
    var errorMessage: String? { get set }
    var showError: Bool { get set }
}

// MARK: - Extension pour les méthodes communes de gestion des erreurs
extension ErrorHandling {
    func handleError(_ error: Error, operation: String) {
        let nsError = error as NSError
        let errorDescription: String
        
        if nsError.domain == "NSCocoaErrorDomain" {
            switch nsError.code {
            case 1550:
                errorDescription = "Des champs obligatoires sont manquants"
            case 1600:
                errorDescription = "Impossible de supprimer cet élément car il est lié à d'autres données"
            case 1670, 1671:
                errorDescription = "La valeur entrée est hors limites"
            default:
                errorDescription = nsError.localizedDescription
            }
        } else {
            errorDescription = nsError.localizedDescription
        }
        
        errorMessage = "\(operation): \(errorDescription)"
        showError = true
    }
    
    func clearError() {
        errorMessage = nil
        showError = false
    }
}
