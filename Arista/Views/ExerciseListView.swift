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
    @State private var animateBackground = false
    var body: some View {
        NavigationView {
            ZStack {
                // Arrière-plan animé
                AngularGradient(gradient: Gradient(colors: [.indigo, .purple, .cyan]), center: .topLeading)
                    .ignoresSafeArea()
                    .hueRotation(.degrees(animateBackground ? 45 : 0))
                    .animation(.easeInOut(duration: 10).repeatForever(autoreverses: true), value: animateBackground)
                // Liste des exercices
                List(viewModel.exercises) { exercise in
                    HStack {
                        Image(systemName: viewModel.iconForCategory(exercise.category ?? ""))
                        VStack(alignment: .leading) {
                            Text(exercise.category ?? "")
                                .font(.headline)
                            Text("Durée: \(exercise.duration) min")
                                .font(.subheadline)
                            Text(exercise.startDate?.formatted() ?? "")
                                .font(.subheadline)
                            
                        }
                        Spacer()
                        IntensityIndicator(intensity: Int(exercise.intensity))
                    }
                }
                .navigationTitle("Exercices")
                .navigationBarItems(trailing: Button(action: {
                    showingAddExerciseView = true
                }) {
                    Image(systemName: "plus")
                })
            }
        }
        .sheet(isPresented: $showingAddExerciseView) {
            AddExerciseView(viewModel: AddExerciseViewModel())
        }
        .onAppear {
            animateBackground = true
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

#Preview {
    ExerciseListView(viewModel: ExerciseListViewModel())
}

