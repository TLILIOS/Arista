//
//  AddExerciseViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class AddExerciseViewModel: ObservableObject {
    @Published var category: String = ""
    @Published var startTime: Date = Date()
    @Published var duration: Int64 = 0
    @Published var intensity: Int64 = 0
    private var viewContext: NSManagedObjectContext
    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }
    func addExercise() -> Bool {
        do {
            try ExerciseRepository(viewContext: viewContext).addExercise(category: category, duration: duration, intensity: intensity, startDate: startTime)
            return true
        } catch {
            return false
        }
    }
}

