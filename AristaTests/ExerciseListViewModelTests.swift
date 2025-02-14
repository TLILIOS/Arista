//
//  ExerciseListViewModelTests.swift
//  AristaTests
//
//  Created by TLiLi Hamdi on 14/02/2025.
//
import XCTest
import CoreData
import Combine
@testable import Arista

final class ExerciseListViewModelTests: XCTestCase {

    var cancellables = Set<AnyCancellable>()
    var persistenceController: PersistenceController!

    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        cancellables.removeAll()
    }

    override func tearDownWithError() throws {
        // Nettoyer les données après chaque test
        emptyEntities(context: persistenceController.container.viewContext)
    }

    func test_WhenNoExerciseIsInDatabase_FetchExercise_ReturnEmptyList() {
        // Arrange
        let repository = ExerciseRepository(viewContext: persistenceController.container.viewContext)
        let viewModel = ExerciseListViewModel(exerciseRepository: repository)
        let expectation = XCTestExpectation(description: "fetch empty list of exercise")

        // Act
        viewModel.refreshExercises()

        // Assert
        viewModel.$exercises
            .sink { exercises in
                XCTAssert(exercises.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10)
    }

    func test_WhenAddingOneExerciseInDatabase_FetchExercise_ReturnAListContainingTheExercise() {
        // Arrange
        let date = Date()
        addExercice(context: persistenceController.container.viewContext,
                    category: "Football", duration: 10, intensity: 5, startDate: date, userFirstName: "Ericw", userLastName: "Marcus")

        let repository = ExerciseRepository(viewContext: persistenceController.container.viewContext)
        let viewModel = ExerciseListViewModel(exerciseRepository: repository)
        let expectation = XCTestExpectation(description: "fetch list containing one exercise")

        // Act
        viewModel.refreshExercises()

        // Assert
        viewModel.$exercises
            .sink { exercises in
                XCTAssertFalse(exercises.isEmpty)
                XCTAssertEqual(exercises.first?.category, "Football")
                XCTAssertEqual(exercises.first?.duration, 10)
                XCTAssertEqual(exercises.first?.intensity, 5)
                XCTAssertEqual(exercises.first?.startDate, date)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10)
    }

    func test_WhenAddingMultipleExerciseInDatabase_FetchExercise_ReturnAListContainingTheExerciseInTheRightOrder() {
        // Arrange
        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60*60*24))
        let date3 = Date(timeIntervalSinceNow: -(60*60*24*2))

        addExercice(context: persistenceController.container.viewContext,
                    category: "Football", duration: 10, intensity: 5, startDate: date1, userFirstName: "Ericn", userLastName: "Marcusi")
        addExercice(context: persistenceController.container.viewContext,
                    category: "Running", duration: 120, intensity: 1, startDate: date3, userFirstName: "Ericb", userLastName: "Marceau")
        addExercice(context: persistenceController.container.viewContext,
                    category: "Fitness", duration: 30, intensity: 5, startDate: date2, userFirstName: "Frédericp", userLastName: "Marcus")

        let repository = ExerciseRepository(viewContext: persistenceController.container.viewContext)
        let viewModel = ExerciseListViewModel(exerciseRepository: repository)
        let expectation = XCTestExpectation(description: "fetch list containing multiple exercises in the right order")

        // Act
        viewModel.refreshExercises()

        // Assert
        viewModel.$exercises
            .sink { exercises in
                XCTAssertEqual(exercises.count, 3)
                XCTAssertEqual(exercises[0].category, "Football")
                XCTAssertEqual(exercises[1].category, "Fitness")
                XCTAssertEqual(exercises[2].category, "Running")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10)
    }

    private func emptyEntities(context: NSManagedObjectContext) {
        let fetchRequest = Exercise.fetchRequest()
        let objects = try! context.fetch(fetchRequest)

        for exercice in objects {
            context.delete(exercice)
        }

        try! context.save()
    }

    private func addExercice(context: NSManagedObjectContext, category: String, duration: Int, intensity: Int, startDate: Date, userFirstName: String, userLastName: String) {
        let newUser = User(context: context)
        newUser.firstName = userFirstName
        newUser.lastName = userLastName
        try! context.save()

        let newExercise = Exercise(context: context)
        newExercise.category = category
        newExercise.duration = Int64(duration)
        newExercise.intensity = Int64(intensity)
        newExercise.startDate = startDate
        newExercise.user = newUser
        try! context.save()
    }
}

/*
 import XCTest
 import Combine
 @testable import Arista

 final class ExerciseListViewModelTests: XCTestCase {
     
     var cancellables = Set<AnyCancellable>()
     
     override func tearDown() {
         cancellables.removeAll()
         super.tearDown()
     }
     
     // MARK: - Mock Repository
     class MockExerciseRepository: ExerciseRepositoryProtocol {
         func addExercise(category: String, duration: Int64, intensity: Int64, startDate: Date) throws {
             
         }
         
         var exercises: [Exercise] = []
         var shouldThrowError = false
         
         func getExercise() throws -> [Exercise] {
             if shouldThrowError {
                 throw NSError(domain: "MockError", code: -1)
             }
             return exercises
         }
         
         func deleteExercises(at offsets: IndexSet, exercises: [Exercise]) throws {
             if shouldThrowError {
                 throw NSError(domain: "MockError", code: -1)
             }
             for index in offsets.sorted(by: >) {
                 self.exercises.remove(at: index)
             }
         }
     }
     
     // MARK: - Tests
     func test_WhenNoExerciseIsInDatabase_FetchExercise_ReturnEmptyList() {
         // Arrange
         let mockRepository = MockExerciseRepository()
         let viewModel = ExerciseListViewModel(exerciseRepository: mockRepository)
         let expectation = XCTestExpectation(description: "fetch empty list")
         
         // Act
         viewModel.refreshExercises()
         
         // Assert
         viewModel.$exercises
             .sink { exercises in
                 XCTAssertTrue(exercises.isEmpty)
                 expectation.fulfill()
             }
             .store(in: &cancellables)
             
         wait(for: [expectation], timeout: 1)
     }
     
     func test_WhenRepositoryHasExercises_FetchExercise_ReturnsList() {
         // Arrange
         let mockRepository = MockExerciseRepository()
         let mockExercise = Exercise(context: PersistenceController(inMemory: true).container.viewContext)
         mockExercise.category = "Football"
         mockExercise.duration = 10
         mockExercise.intensity = 5
         mockExercise.startDate = Date()
         mockRepository.exercises = [mockExercise]
         
         let viewModel = ExerciseListViewModel(exerciseRepository: mockRepository)
         let expectation = XCTestExpectation(description: "fetch exercises list")
         
         // Act
         viewModel.refreshExercises()
         
         // Assert
         viewModel.$exercises
             .sink { exercises in
                 XCTAssertFalse(exercises.isEmpty)
                 XCTAssertEqual(exercises.first?.category, "Football")
                 XCTAssertEqual(exercises.first?.duration, 10)
                 XCTAssertEqual(exercises.first?.intensity, 5)
                 expectation.fulfill()
             }
             .store(in: &cancellables)
             
         wait(for: [expectation], timeout: 1)
     }
     
     func test_WhenRepositoryThrowsError_ShowsError() {
              // Arrange
              let mockRepository = MockExerciseRepository()
              mockRepository.shouldThrowError = true
              let viewModel = ExerciseListViewModel(exerciseRepository: mockRepository)
              let expectation = XCTestExpectation(description: "show error")
              
              // Act & Assert
              viewModel.$showError
                  .dropFirst() // Drop initial false
                  .sink { showError in
                      if showError {
                          expectation.fulfill()
                      }
                  }
                  .store(in: &cancellables)
              
              // Attendre que l'initialisation soit terminée
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                  viewModel.refreshExercises()
              }
              
              wait(for: [expectation], timeout: 2)
          }
          
          func test_DeleteExercise_RemovesFromList() {
              // Arrange
              let mockRepository = MockExerciseRepository()
              let mockExercise = Exercise(context: PersistenceController(inMemory: true).container.viewContext)
              mockExercise.category = "Football"
              mockRepository.exercises = [mockExercise]
              
              let viewModel = ExerciseListViewModel(exerciseRepository: mockRepository)
              let expectation = XCTestExpectation(description: "delete exercise")
              
              // Act & Assert
              viewModel.$exercises
                  .dropFirst(2) // Drop initial empty array and the first refresh
                  .sink { exercises in
                      XCTAssertTrue(exercises.isEmpty)
                      expectation.fulfill()
                  }
                  .store(in: &cancellables)
              
              viewModel.refreshExercises() // Load initial state
              viewModel.deleteExercises(at: IndexSet(integer: 0))
              
              wait(for: [expectation], timeout: 2)
          }
 }
 */
