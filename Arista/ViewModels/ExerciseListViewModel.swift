//
//  ExerciseListViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation


class ExerciseListViewModel: ObservableObject, ErrorHandling {
    
    @Published var exercises = [Exercise]()
    @Published var errorMessage: String?
    @Published var showError = false
    let exerciseRepository: ExerciseRepository = ExerciseRepository()
    
    
    init() {
        refreshExercises()
    }
    
    // Rafraîchit la liste des exercices depuis CoreData
    func refreshExercises() {
        do {
            exercises = try exerciseRepository.getExercise()
            // Effacer les erreurs précédentes en cas de succès
            clearError()
        } catch {
            handleError(error, operation: "Impossible de charger les exercices")
        }
    }
    
    func deleteExercises(at offsets: IndexSet) {
 
        do {
           try  exerciseRepository.deleteExercises(at: offsets, exercises: exercises)
          
            refreshExercises()
        } catch {
            handleError(error, operation: "Impossible de supprimer l'exercice")
            // Recharger les exercices pour assurer la synchronisation avec l'interface
            refreshExercises()
        }
    }

}
