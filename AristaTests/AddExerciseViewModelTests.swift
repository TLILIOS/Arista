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
            if shouldThrowError {
                throw NSError(domain: "MockError", code: -1)
            }
            addedExercises.append((category, duration, intensity, startDate))
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
        XCTAssertTrue(result)
        XCTAssertEqual(mockRepository.addedExercises.count, 1)
        XCTAssertEqual(mockRepository.addedExercises[0].category, "Football")
        XCTAssertEqual(mockRepository.addedExercises[0].duration, 30)
        XCTAssertEqual(mockRepository.addedExercises[0].intensity, 5)
        XCTAssertEqual(mockRepository.addedExercises[0].startDate, testDate)
    }
    
    func test_AddExercise_Failure() {
        // Arrange
        let mockRepository = MockExerciseRepository()
        mockRepository.shouldThrowError = true
        let viewModel = AddExerciseViewModel(exerciseRepository: mockRepository)
        
        // Act
        let result = viewModel.addExercise()
        
        // Assert
        XCTAssertFalse(result)
        XCTAssertTrue(mockRepository.addedExercises.isEmpty)
    }
}
