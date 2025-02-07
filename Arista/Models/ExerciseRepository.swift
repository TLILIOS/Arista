//
//  ExerciseRepository.swift
//  Arista
//
//  Created by TLiLi Hamdi on 02/02/2025.
//

import Foundation
import CoreData

struct ExerciseRepository {
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    func getExercise() throws -> [Exercise] {
        let request = Exercise.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(SortDescriptor<Exercise>(\.startDate, order: .reverse))]
        return try viewContext.fetch(request)
    }
    
    func addExercise(category: String, duration: Int64, intensity: Int64, startDate: Date) throws {
        let newExercise = Exercise(context: viewContext)
        newExercise.category = category
        newExercise.duration = duration
        newExercise.intensity = intensity
        newExercise.startDate = startDate
        try viewContext.save()
    }
}
