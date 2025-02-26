//
//  AddExerciseViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation

class AddExerciseViewModel: ObservableObject {
    @Published var category: String = ""
    @Published var startTime: Date = Date()
    @Published var duration: Int64 = 0
    @Published var intensity: Int64 = 0
    @Published var errorMessage: String? = nil
    private let exerciseRepository: ExerciseRepositoryProtocol
    
    init(exerciseRepository: ExerciseRepositoryProtocol = ExerciseRepository()) {
        self.exerciseRepository = exerciseRepository
    }
  
    // Méthode de validation
        func validate() -> Bool {
            if category.isEmpty {
                errorMessage = "La catégorie est obligatoire."
                return false
            }
            if duration <= 0 {
                errorMessage = "La durée doit être supérieure à 0."
                return false
            }
            if intensity < 0 || intensity > 10 {
                errorMessage = "L'intensité doit être comprise entre 0 et 10."
                return false
            }
            errorMessage = nil // Réinitialiser le message d'erreur si tout est valide
            return true
        }
    
    func addExercise() -> Bool {
        guard validate() else {
                   
                   return false
               }
        do {
            try exerciseRepository.addExercise(
                category: category,
                duration: duration,
                intensity: intensity,
                startDate: startTime
            )
           
            return true
        } catch {
            errorMessage = "Erreur lors de l'ajout de l'exercice : \(error.localizedDescription)"
            return false
        }
    }
}

