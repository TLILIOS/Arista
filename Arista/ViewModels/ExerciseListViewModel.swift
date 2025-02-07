//
//  ExerciseListViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class ExerciseListViewModel: ObservableObject {
    @Published var exercises = [Exercise]()
    @Published var errorMessage: String?
    @Published var showError = false
    
    var viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        refreshExercises()
    }
    
    /// Rafraîchit la liste des exercices depuis CoreData
    func refreshExercises() {
        do {
            let data = ExerciseRepository(viewContext: viewContext)
            exercises = try data.getExercise()
            // Effacer les erreurs précédentes en cas de succès
            errorMessage = nil
            showError = false
        } catch {
            handleError(error, operation: "Impossible de charger les exercices")
        }
    }
    
    /// Alias pour refreshExercises pour maintenir la compatibilité
    func fetchExercises() {
        refreshExercises()
    }
    
    func deleteExercises(at offsets: IndexSet) {
        offsets.forEach { index in
            let exercise = exercises[index]
            viewContext.delete(exercise)
        }
        
        do {
            try viewContext.save()
            refreshExercises()
        } catch {
            handleError(error, operation: "Impossible de supprimer l'exercice")
            // Recharger les exercices pour assurer la synchronisation avec l'interface
            refreshExercises()
        }
    }

    private func handleError(_ error: Error, operation: String) {
        let nsError = error as NSError
        let errorDescription: String
        
        // Gestion spécifique des erreurs de validation CoreData
        if nsError.domain == "NSCocoaErrorDomain" {
            switch nsError.code {
            case 1550:
                errorDescription = "Des champs obligatoires sont manquants"
            case 1600:
                errorDescription = "Impossible de supprimer cet exercice car il est lié à d'autres données"
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
}
