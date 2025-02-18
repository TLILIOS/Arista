////
////  ExerciseRepositoryTests.swift
////  AristaTests
////
////  Created by TLiLi Hamdi on 12/02/2025.
////
//
//import XCTest
//import CoreData
//@testable import Arista
//
//final class ExerciseRepositoryTests: XCTestCase {
//    
//    private func emptyEntities(context: NSManagedObjectContext) {
//        
//        let fetchRequest = Exercise.fetchRequest()
//        
//        let objects = try! context.fetch(fetchRequest)
//        
//        
//        
//        for exercice in objects {
//            
//            context.delete(exercice)
//            
//        }
//        
//        
//        
//        try! context.save()
//        
//    }
//    
//    private func addExercice(context: NSManagedObjectContext, category: String, duration: Int, intensity: Int, startDate: Date, userFirstName: String, userLastName: String) {
//        
//        let newUser = User(context: context)
//        
//        newUser.firstName = userFirstName
//        
//        newUser.lastName = userLastName
//        
//        try! context.save()
//        
//        
//        
//        let newExercise = Exercise(context: context)
//        
//        newExercise.category = category
//        
//        newExercise.duration = Int64(duration)
//        
//        newExercise.intensity = Int64(intensity)
//        
//        newExercise.startDate = startDate
//        
//        newExercise.user = newUser
//        
//        try! context.save()
//        
//    }
//    
//    func test_WhenNoExerciseIsInDatabase_GetExercise_ReturnEmptyList() {
//        
//        // Clean manually all data
//        
//        let persistenceController = PersistenceController(inMemory: true)
//        
//        emptyEntities(context: persistenceController.container.viewContext)
//        
//        let data = ExerciseRepository(viewContext: persistenceController.container.viewContext)
//        
//        let exercises = try! data.getExercise()
//        
//        XCTAssert(exercises.isEmpty == true)
//        
//    }
//    
//    func test_WhenAddingOneExerciseInDatabase_GetExercise_ReturnAListContainingTheExercise() {
//        
//        // Clean manually all data
//        
//        let persistenceController = PersistenceController(inMemory: true)
//        
//        emptyEntities(context: persistenceController.container.viewContext)
//        
//        let date = Date()
//        
//        addExercice(context: persistenceController.container.viewContext, category: "Football", duration: 10, intensity: 5, startDate: date, userFirstName: "Eric", userLastName: "Marcus")
//        
//        
//        
//        let data = ExerciseRepository(viewContext: persistenceController.container.viewContext)
//        
//        let exercises = try! data.getExercise()
//        
//        
//        
//        XCTAssert(exercises.isEmpty == false)
//        
//        XCTAssert(exercises.first?.category == "Football")
//        
//        XCTAssert(exercises.first?.duration == 10)
//        
//        XCTAssert(exercises.first?.intensity == 5)
//        
//        XCTAssert(exercises.first?.startDate == date)
//        
//    }
//    
//    func test_WhenAddingMultipleExerciseInDatabase_GetExercise_ReturnAListContainingTheExerciseInTheRightOrder() {
//        
//        // Clean manually all data
//        
//        let persistenceController = PersistenceController(inMemory: true)
//        
//        emptyEntities(context: persistenceController.container.viewContext)
//        
//        let date1 = Date()
//        
//        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
//        
//        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2))
//        
//        
//        
//        addExercice(context: persistenceController.container.viewContext,
//                    
//                    category: "Football",
//                    
//                    duration: 10,
//                    
//                    intensity: 5,
//                    
//                    startDate: date1,
//                    
//                    userFirstName: "Erica",
//                    
//                    userLastName: "Marcusi")
//        
//        addExercice(context: persistenceController.container.viewContext,
//                    
//                    category: "Running",
//                    
//                    duration: 120,
//                    
//                    intensity: 1,
//                    
//                    startDate: date3,
//                    
//                    userFirstName: "Erice",
//                    
//                    userLastName: "Marceau")
//        
//        addExercice(context: persistenceController.container.viewContext,
//                    
//                    category: "Fitness",
//                    
//                    duration: 30,
//                    
//                    intensity: 5,
//                    
//                    startDate: date2,
//                    
//                    userFirstName: "Frédericd",
//                    
//                    userLastName: "Marcus")
//        
//        
//        
//        let data = ExerciseRepository(viewContext: persistenceController.container.viewContext)
//        
//        let exercises = try! data.getExercise()
//        
//        
//        
//        XCTAssert(exercises.count == 3)
//        
//        XCTAssert(exercises[0].category == "Football")
//        
//        XCTAssert(exercises[1].category == "Fitness")
//        
//        XCTAssert(exercises[2].category == "Running")
//        
//    }
//    
//    // TEST 1 : Ajout simple d’un exercice
//        func test_WhenAddingOneExercise_AddExercise_SavesExerciseInDatabase() throws {
//            let persistenceController = PersistenceController(inMemory: true)
//            let context = persistenceController.container.viewContext
//            emptyEntities(context: context)
//            
//            let repository = ExerciseRepository(viewContext: context)
//            
//            let date = Date()
//            try repository.addExercise(category: "Football", duration: 60, intensity: 3, startDate: date)
//            
//            let exercises = try repository.getExercise()
//            
//            XCTAssertEqual(exercises.count, 1)
//            XCTAssertEqual(exercises.first?.category, "Football")
//            XCTAssertEqual(exercises.first?.duration, 60)
//            XCTAssertEqual(exercises.first?.intensity, 3)
//            XCTAssertEqual(exercises.first?.startDate, date)
//        }
//        
//        // TEST 2 : Ajout de plusieurs exercices
//        func test_WhenAddingMultipleExercises_AddExercise_SavesAllExercises() throws {
//            let persistenceController = PersistenceController(inMemory: true)
//            let context = persistenceController.container.viewContext
//            emptyEntities(context: context)
//            
//            let repository = ExerciseRepository(viewContext: context)
//            
//            try repository.addExercise(category: "Football", duration: 60, intensity: 3, startDate: Date())
//            try repository.addExercise(category: "Running", duration: 45, intensity: 5, startDate: Date())
//            try repository.addExercise(category: "Cycling", duration: 90, intensity: 2, startDate: Date())
//            
//            let exercises = try repository.getExercise()
//            
//            XCTAssertEqual(exercises.count, 3)
//            XCTAssertTrue(exercises.contains { $0.category == "Football" })
//            XCTAssertTrue(exercises.contains { $0.category == "Running" })
//            XCTAssertTrue(exercises.contains { $0.category == "Cycling" })
//        }
//        
//        // TEST 3 : Ajout avec des valeurs limites (zero, vide)
//        func test_WhenAddingExerciseWithEdgeValues_AddExercise_SavesExerciseWithEdgeValues() throws {
//            let persistenceController = PersistenceController(inMemory: true)
//            let context = persistenceController.container.viewContext
//            emptyEntities(context: context)
//            
//            let repository = ExerciseRepository(viewContext: context)
//            
//            let date = Date()
//            try repository.addExercise(category: "", duration: 0, intensity: 0, startDate: date)
//            
//            let exercises = try repository.getExercise()
//            
//            XCTAssertEqual(exercises.count, 1)
//            XCTAssertEqual(exercises.first?.category, "")
//            XCTAssertEqual(exercises.first?.duration, 0)
//            XCTAssertEqual(exercises.first?.intensity, 0)
//            XCTAssertEqual(exercises.first?.startDate, date)
//        }
//    
//}
import XCTest
import CoreData
@testable import Arista

class ExerciseRepositoryTests: XCTestCase {
    
    var repository: ExerciseRepository!
    var testContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        // Setup in-memory Core Data stack
        let persistenceController = PersistenceController(inMemory: true)
        testContext = persistenceController.container.viewContext
        repository = ExerciseRepository(viewContext: testContext)
    }
    
    override func tearDown() {
        repository = nil
        testContext = nil
        super.tearDown()
    }
    
    // MARK: - Get Exercises Tests
    
    func testGetExercises_WhenNoExercises_ReturnsEmpty() throws {
        let exercises = try repository.getExercise()
        XCTAssertTrue(exercises.isEmpty, "Expected no exercises, but found \(exercises.count).")
    }
    
    func testGetExercises_SortedByStartDateDescending() throws {
        // Add exercises with different dates
        let date1 = Date().addingTimeInterval(-3600) // 1 hour ago
        let date2 = Date() // Now
        
        try repository.addExercise(category: "Running", duration: 30, intensity: 3, startDate: date1)
        try repository.addExercise(category: "Cycling", duration: 45, intensity: 2, startDate: date2)
        
        let exercises = try repository.getExercise()
        
        XCTAssertEqual(exercises.count, 2, "Expected 2 exercises.")
        XCTAssertEqual(exercises[0].category, "Cycling", "First exercise should be the latest.")
        XCTAssertEqual(exercises[1].category, "Running", "Second exercise should be the earliest.")
    }
    
    // MARK: - Add Exercise Tests
    
    func testAddExercise_SavesCorrectAttributes() throws {
        let category = "Swimming"
        let duration: Int64 = 20
        let intensity: Int64 = 4
        let startDate = Date()
        
        try repository.addExercise(category: category, duration: duration, intensity: intensity, startDate: startDate)
        
        let exercises = try repository.getExercise()
        XCTAssertEqual(exercises.count, 1, "Expected 1 exercise.")
        
        let exercise = exercises[0]
        XCTAssertEqual(exercise.category, category)
        XCTAssertEqual(exercise.duration, duration)
        XCTAssertEqual(exercise.intensity, intensity)
        XCTAssertEqual(exercise.startDate, startDate)
    }
    
    // MARK: - Delete Exercises Tests
    
    func testDeleteExercises_DeletesSingleExercise() throws {
        try repository.addExercise(category: "Yoga", duration: 30, intensity: 1, startDate: Date())
        var exercises = try repository.getExercise()
        XCTAssertEqual(exercises.count, 1, "Setup failed: Expected 1 exercise.")
        
        try repository.deleteExercises(at: IndexSet(integer: 0), exercises: exercises)
        
        exercises = try repository.getExercise()
        XCTAssertTrue(exercises.isEmpty, "Exercise should be deleted.")
    }
    
    func testDeleteExercises_DeletesMultipleExercises() throws {
        // Add 3 exercises
        try repository.addExercise(category: "A", duration: 10, intensity: 1, startDate: Date())
        try repository.addExercise(category: "B", duration: 20, intensity: 2, startDate: Date())
        try repository.addExercise(category: "C", duration: 30, intensity: 3, startDate: Date())
        var exercises = try repository.getExercise()
        XCTAssertEqual(exercises.count, 3, "Setup failed: Expected 3 exercises.")
        
        // Delete first and third
        try repository.deleteExercises(at: IndexSet([0, 2]), exercises: exercises)
        
        exercises = try repository.getExercise()
        XCTAssertEqual(exercises.count, 1, "Expected 1 remaining exercise.")
        XCTAssertEqual(exercises[0].category, "B", "Remaining exercise should be 'B'.")
    }
    
    func testDeleteExercises_WithInvalidIndex_DoesNothing() throws {
        try repository.addExercise(category: "Test", duration: 10, intensity: 1, startDate: Date())
        let exercises = try repository.getExercise()
        XCTAssertEqual(exercises.count, 1, "Setup failed: Expected 1 exercise.")
        
        // Attempt to delete at invalid index
        try repository.deleteExercises(at: IndexSet(integer: 5), exercises: exercises)
        
        let remainingExercises = try repository.getExercise()
        XCTAssertEqual(remainingExercises.count, 1, "Exercise count should remain unchanged.")
    }
    
    // MARK: - Error Handling Tests
    
    func testAddExercise_WithInvalidData_ThrowsError() {
        // Simulate invalid data by using a closed context
        let invalidContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        invalidContext.persistentStoreCoordinator = nil // No persistent store, will cause save failure
        let invalidRepository = ExerciseRepository(viewContext: invalidContext)
        
        XCTAssertThrowsError(
            try invalidRepository.addExercise(category: "Fail", duration: 0, intensity: 0, startDate: Date()),
            "Adding exercise with invalid context should throw an error."
        )
    }
}
