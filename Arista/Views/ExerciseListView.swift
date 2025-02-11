//
//  ExerciseListView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct ExerciseListView: View {
    @ObservedObject var viewModel: ExerciseListViewModel
    @State private var showingAddExerciseView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.exercises) { exercise in
                    HStack {
                        Image(systemName: iconForCategory(exercise.category ?? ""))
                        VStack(alignment: .leading) {
                            Text(exercise.category ?? "")
                                .font(.headline)
                            Text("Durée: \(exercise.duration) min")
                                .font(.subheadline)
                            Text(exercise.startDate?.formatted() ?? "Date inconnue")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        IntensityIndicator(intensity: Int(exercise.intensity))
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            if let index = viewModel.exercises.firstIndex(of: exercise) {
                                viewModel.deleteExercises(at: IndexSet([index]))
                            }
                        } label: {
                            Label("Supprimer", systemImage: "trash")
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showingAddExerciseView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("Exercices")
            .alert("Erreur", isPresented: $viewModel.showError, presenting: viewModel.errorMessage) { _ in
                Button("OK", role: .cancel) {}
            } message: { errorMessage in
                Text(errorMessage)
            }
        }
        .sheet(isPresented: $showingAddExerciseView) {
            AddExerciseView(viewModel: AddExerciseViewModel(),
                            onExerciseAdded: {
                viewModel.refreshExercises()
            })
        }
        .onAppear {
            viewModel.refreshExercises()
        }
        .onDisappear {
            viewModel.refreshExercises()
        }
        .onChange(of: showingAddExerciseView) { _, isShowing in
            if !isShowing {
                // Rafraîchir la liste quand la vue d'ajout se ferme
                viewModel.refreshExercises()
            }
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

struct IntensityIndicator: View {
    var intensity: Int
    
    var body: some View {
        Circle()
            .fill(colorForIntensity(intensity))
            .frame(width: 10, height: 10)
    }
    
    func colorForIntensity(_ intensity: Int) -> Color {
        switch intensity {
        case 0...3:
            return .green
        case 4...6:
            return .yellow
        case 7...10:
            return .red
        default:
            return .gray
        }
    }
}

//#Preview {
//    ExerciseListView(viewModel: ExerciseListViewModel(context: PersistenceController.preview.container.viewContext))
//}
