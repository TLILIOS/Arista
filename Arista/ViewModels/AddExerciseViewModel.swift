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
    
    private let exerciseRepository: ExerciseRepositoryProtocol
    
    init(exerciseRepository: ExerciseRepositoryProtocol = ExerciseRepository()) {
        self.exerciseRepository = exerciseRepository
    }
  
    func addExercise() -> Bool {
        print("ViewModel: Tentative d'ajout d'un exercice - Catégorie: \(category), Durée: \(duration), Intensité: \(intensity), Date: \(startTime)")
        do {
            try exerciseRepository.addExercise(
                category: category,
                duration: duration,
                intensity: intensity,
                startDate: startTime
            )
            print("ViewModel: Exercice ajouté avec succès")
            return true
        } catch {
            print("ViewModel: Erreur lors de l'ajout de l'exercice - \(error)")
            return false
        }
    }
}

