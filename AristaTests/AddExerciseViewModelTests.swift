//
//  AddExerciseViewModelTests.swift
//  AristaTests
//
//  Created by TLiLi Hamdi on 14/02/2025.
//
import XCTest
import Combine
@testable import Arista

final class AddExerciseViewModelTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    // MARK: - Mock Repository
    class MockExerciseRepository: ExerciseRepositoryProtocol {
        var shouldThrowError = false
        var addedExercises: [(category: String, duration: Int64, intensity: Int64, startDate: Date)] = []
        
        func getExercise() throws -> [Exercise] {
            return []
        }
        
        func deleteExercises(at offsets: IndexSet, exercises: [Exercise]) throws {}
        
        func addExercise(category: String, duration: Int64, intensity: Int64, startDate: Date) throws {
            print("MockRepository: Ajout d'un exercice - Catégorie: \(category), Durée: \(duration), Intensité: \(intensity), Date: \(startDate)")
            if shouldThrowError {
                print("MockRepository: Erreur simulée lors de l'ajout de l'exercice")
                throw NSError(domain: "MockError", code: -1)
            }
            addedExercises.append((category, duration, intensity, startDate))
            print("MockRepository: Exercice ajouté avec succès")
        }
    }
    
    func test_AddExercise_Success() {
        // Arrange
        let mockRepository = MockExerciseRepository()
        let viewModel = AddExerciseViewModel(exerciseRepository: mockRepository)
        let testDate = Date()
        
        // Act
        viewModel.category = "Football"
        viewModel.duration = 30
        viewModel.intensity = 5
        viewModel.startTime = testDate
        
        let result = viewModel.addExercise()
        
        // Assert
        XCTAssertTrue(result, "Expected addExercise to return true")
        XCTAssertEqual(mockRepository.addedExercises.count, 1, "Expected one exercise to be added")
        
        if mockRepository.addedExercises.count > 0 {
            XCTAssertEqual(mockRepository.addedExercises[0].category, "Football", "Category mismatch")
            XCTAssertEqual(mockRepository.addedExercises[0].duration, 30, "Duration mismatch")
            XCTAssertEqual(mockRepository.addedExercises[0].intensity, 5, "Intensity mismatch")
            XCTAssertEqual(mockRepository.addedExercises[0].startDate, testDate, "Start date mismatch")
        } else {
            XCTFail("No exercise was added to the repository")
        }
    }
    
    func test_AddExercise_Failure() {
        // Arrange
        let mockRepository = MockExerciseRepository()
        mockRepository.shouldThrowError = true
        let viewModel = AddExerciseViewModel(exerciseRepository: mockRepository)
        viewModel.category = "Football"
        viewModel.duration = 30
        viewModel.intensity = 5
        viewModel.startTime = Date()
        
        // Act
        let result = viewModel.addExercise()
        
        // Assert
        XCTAssertFalse(result, "Expected addExercise to return false due to error")
        XCTAssertTrue(mockRepository.addedExercises.isEmpty, "Expected no exercises to be added")
    }
}
