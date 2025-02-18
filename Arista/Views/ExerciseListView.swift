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
                ForEach(viewModel.exercises) { exercise in ExerciseRowView(exercise: exercise, onDelete: {
                    if let index = viewModel.exercises.firstIndex(of: exercise) {
                        viewModel.deleteExercises(at: IndexSet([index]))
                    }
                },
                iconName: viewModel.iconForCategory(exercise.category ?? "")
                )
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
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
