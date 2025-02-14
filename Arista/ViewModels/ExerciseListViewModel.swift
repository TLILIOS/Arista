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
    
    private let exerciseRepository: ExerciseRepositoryProtocol
    func icon(for exercise: Exercise) -> String {
        return iconForCategory(exercise.category ?? "")
    }
    
    
    init(exerciseRepository: ExerciseRepositoryProtocol = ExerciseRepository()) {
        self.exerciseRepository = exerciseRepository
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
    func iconForCategory(_ category: String) -> String {
        switch category {
        case "Football":
            return "sportscourt"
        case "Natation":
            return "waveform.path.ecg"
        case "Running":
            return "figure.run"
        case "Marche":
            return "figure.walk"
        case "Cyclisme":
            return "bicycle"
        case "Basketball":
            return "basketball"
        case "Tennis":
            return "tennis.racket"
        case "Yoga":
            return "figure.yoga"
        case "Golf":
            return "figure.golf"
        case "Escalade":
            return "figure.climbing"
        case "Musculation":
            return "dumbbell"
        case "Randonnée":
            return "figure.hiking"
        case "Danse":
            return "figure.dance"
        case "Boxe":
            return "figure.boxing"
        case "Ski":
            return "figure.skiing"
        case "Surf":
            return "figure.surfing"
        default:
            return "person.fill.questionmark"
        }
    }

}
