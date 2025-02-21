//
//  ExerciseRowView.swift
//  Arista
//
//  Created by TLiLi Hamdi on 11/02/2025.
//

import SwiftUI

struct ExerciseRowView: View {
    let exercise: Exercise
    let onDelete: () -> Void
    let iconName: String
    var body: some View {
        HStack {
            Image(systemName: iconName)
            VStack(alignment: .leading) {
                Text(exercise.category ?? "")
                    .font(.headline)
                Text("Durée: \(exercise.duration) min")
                    .font(.subheadline)
                Text(exercise.startDate?.formatted() ?? "Date inconnue")
                    .font(.subheadline)
            }
            
          
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: onDelete) {
                Label("Supprimer", systemImage: "trash")
            }
        }
    }
}

#Preview {
    let exercise = Exercise(context: PersistenceController.preview.container.viewContext)
    exercise.category = "Running"
    exercise.duration = 30
    exercise.intensity = 5
    exercise.startDate = Date()
    
    return ExerciseRowView(
        exercise: exercise, // Exercice de démonstration
        onDelete: {
            print("Suppression de l'exercice")
        },
        iconName: "figure.run" // Icône de démonstration
    )
}
