//
//  ExerciseRepository.swift
//  Arista
//
//  Created by TLiLi Hamdi on 02/02/2025.
//

import Foundation
import CoreData

protocol ExerciseRepositoryProtocol {
    func getExercise() throws -> [Exercise]
    func addExercise(category: String, duration: Int64, intensity: Int64, startDate: Date) throws
    func deleteExercises(at offsets: IndexSet , exercises: [Exercise]) throws
}

struct ExerciseRepository: ExerciseRepositoryProtocol {
    
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

    public func deleteExercises(at indexSet: IndexSet, exercises: [Exercise]) throws {
        // Filtrer les indices pour ne garder que ceux qui sont valides
        let validIndices = indexSet.filter { $0 < exercises.count }
        for index in validIndices {
            let exercise = exercises[index]
            viewContext.delete(exercise)
        }
        try viewContext.save()
    }

}
