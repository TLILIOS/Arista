//
//  AddExerciseView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct AddExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddExerciseViewModel
    var onExerciseAdded: (() -> Void)? // CallBack func
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
            VStack {
                Form {
                    TextField("Catégorie", text: $viewModel.category)
                    DatePicker("Heure de démarrage", selection: $viewModel.startTime, displayedComponents: [.date, .hourAndMinute])
                    Stepper("Durée: \(viewModel.duration) minutes", value: Binding(
                        get: { Int(viewModel.duration) },
                        set: { viewModel.duration = Int64($0) }
                    ), in: 0...1440)
                    Stepper("Intensité: \(viewModel.intensity)", value: Binding(
                        get: { Int(viewModel.intensity) },
                        set: { viewModel.intensity = Int64($0) }
                    ), in: 0...10)
                }.formStyle(.grouped)
                // Affichage des messages d'erreur
                                    if let errorMessage = viewModel.errorMessage {
                                        Text(errorMessage)
                                            .foregroundColor(.red)
                                            .padding()
                                    }
                Spacer()
                Button("Ajouter l'exercice") {
                    if viewModel.addExercise() {
                        onExerciseAdded?()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.category.isEmpty)
                
            }

        }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .navigationTitle("Nouvel Exercice ...")
            
        }
    }
}

#Preview {
    AddExerciseView(viewModel: AddExerciseViewModel())
}
