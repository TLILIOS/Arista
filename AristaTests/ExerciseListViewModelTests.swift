
import XCTest
@testable import Arista

@MainActor
final class ExerciseListViewModelTests: XCTestCase {
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Mock Repository
    class MockExerciseRepository: ExerciseRepositoryProtocol {
        func addExercise(category: String, duration: Int64, intensity: Int64, startDate: Date) throws {
            let newExercise = Exercise(context: PersistenceController(inMemory: true).container.viewContext)
            newExercise.category = category
            newExercise.duration = duration
            newExercise.intensity = intensity
            newExercise.startDate = startDate
            exercises.append(newExercise)
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
        let mockRepository = MockExerciseRepository()
        let viewModel = ExerciseListViewModel(exerciseRepository: mockRepository)
        
        viewModel.refreshExercises()
        
        XCTAssertTrue(viewModel.exercises.isEmpty)
    }
    
    func test_WhenRepositoryHasExercises_FetchExercise_ReturnsList() {
        let mockRepository = MockExerciseRepository()
        let mockExercise = Exercise(context: PersistenceController(inMemory: true).container.viewContext)
        mockExercise.category = "Football"
        mockExercise.duration = 10
        mockExercise.intensity = 5
        mockExercise.startDate = Date()
        mockRepository.exercises = [mockExercise]
        
        let viewModel = ExerciseListViewModel(exerciseRepository: mockRepository)
        viewModel.refreshExercises()
        
        XCTAssertFalse(viewModel.exercises.isEmpty)
        XCTAssertEqual(viewModel.exercises.first?.category, "Football")
        XCTAssertEqual(viewModel.exercises.first?.duration, 10)
        XCTAssertEqual(viewModel.exercises.first?.intensity, 5)
    }
    
    func test_WhenRepositoryThrowsError_ShowsError() {
        let mockRepository = MockExerciseRepository()
        mockRepository.shouldThrowError = true
        let viewModel = ExerciseListViewModel(exerciseRepository: mockRepository)
        
        viewModel.refreshExercises()
        
        XCTAssertTrue(viewModel.showError)
    }
    
    func test_DeleteExercise_RemovesFromList() {
        let mockRepository = MockExerciseRepository()
        let mockExercise = Exercise(context: PersistenceController(inMemory: true).container.viewContext)
        mockExercise.category = "Football"
        mockRepository.exercises = [mockExercise]

        let viewModel = ExerciseListViewModel(exerciseRepository: mockRepository)
        viewModel.refreshExercises()
        
        viewModel.deleteExercises(at: IndexSet(integer: 0))

        XCTAssertTrue(viewModel.exercises.isEmpty, "Exercise list should be empty after deletion.")
    }
    
    func test_DeleteExercise_WhenRepositoryThrowsError_ShowsError() {
        let mockRepository = MockExerciseRepository()
        mockRepository.shouldThrowError = true
        let mockExercise = Exercise(context: PersistenceController(inMemory: true).container.viewContext)
        mockExercise.category = "Football"
        mockRepository.exercises = [mockExercise]

        let viewModel = ExerciseListViewModel(exerciseRepository: mockRepository)
        viewModel.refreshExercises()
        
        viewModel.deleteExercises(at: IndexSet(integer: 0))

        XCTAssertTrue(viewModel.showError, "showError should be true when deletion fails.")
    }
    
    func test_AddExercise_IncreasesExerciseList() throws {
        let mockRepository = MockExerciseRepository()
        let viewModel = ExerciseListViewModel(exerciseRepository: mockRepository)
        
        try mockRepository.addExercise(category: "Tennis", duration: 60, intensity: 3, startDate: Date())
        viewModel.refreshExercises()
        
        XCTAssertEqual(viewModel.exercises.count, 1, "Exercise should be added to the list.")
        XCTAssertEqual(viewModel.exercises.first?.category, "Tennis")
    }
    
    func test_IconForExercise_ReturnsCorrectIcon() {
        // Arrange
        let viewModel = ExerciseListViewModel()
        let context = PersistenceController(inMemory: true).container.viewContext
        
        let testCases: [(category: String?, expectedIcon: String)] = [
            ("Football", "sportscourt"),
            ("Natation", "waveform.path.ecg"),
            ("Running", "figure.run"),
            ("Marche", "figure.walk"),
            ("Cyclisme", "bicycle"),
            ("Basketball", "basketball"),
            ("Tennis", "tennis.racket"),
            ("Yoga", "figure.yoga"),
            ("Golf", "figure.golf"),
            ("Escalade", "figure.climbing"),
            ("Musculation", "dumbbell"),
            ("Randonnée", "figure.hiking"),
            ("Danse", "figure.dance"),
            ("Boxe", "figure.boxing"),
            ("Ski", "figure.skiing"),
            ("Surf", "figure.surfing"),
            (nil, "person.fill.questionmark"), // Cas où la catégorie est nil
            ("", "person.fill.questionmark"), // Cas où la catégorie est vide
            ("Inconnu", "person.fill.questionmark") // Cas où la catégorie est inconnue
        ]
        
        // Act & Assert
        for (category, expectedIcon) in testCases {
            let exercise = Exercise(context: context)
            exercise.category = category
            
            XCTAssertEqual(viewModel.icon(for: exercise), expectedIcon, "L'icône pour '\(category ?? "nil")' devrait être '\(expectedIcon)'")
        }
    }
    func test_IconForCategory_ReturnsCorrectIcon() {
        // Arrange
        let viewModel = ExerciseListViewModel()
        
        let categoryIcons: [(category: String, expectedIcon: String)] = [
            ("Football", "sportscourt"),
            ("Natation", "waveform.path.ecg"),
            ("Running", "figure.run"),
            ("Marche", "figure.walk"),
            ("Cyclisme", "bicycle"),
            ("Basketball", "basketball"),
            ("Tennis", "tennis.racket"),
            ("Yoga", "figure.yoga"),
            ("Golf", "figure.golf"),
            ("Escalade", "figure.climbing"),
            ("Musculation", "dumbbell"),
            ("Randonnée", "figure.hiking"),
            ("Danse", "figure.dance"),
            ("Boxe", "figure.boxing"),
            ("Ski", "figure.skiing"),
            ("Surf", "figure.surfing"),
            ("", "person.fill.questionmark"), // Cas où la catégorie est vide
            ("Inconnu", "person.fill.questionmark") // Cas où la catégorie est inconnue
        ]
        
        // Act & Assert
        for (category, expectedIcon) in categoryIcons {
            XCTAssertEqual(viewModel.iconForCategory(category), expectedIcon, "L'icône pour '\(category)' devrait être '\(expectedIcon)'")
        }
    }
}
