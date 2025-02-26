//
//  AddExerciseViewModelTests.swift
//  AristaTests
//
//  Created by TLiLi Hamdi on 14/02/2025.
//
import XCTest
@testable import Arista

final class AddExerciseViewModelTests: XCTestCase {
    var viewModel: AddExerciseViewModel!
    var mockRepository: MockExerciseRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockExerciseRepository()
        viewModel = AddExerciseViewModel(exerciseRepository: mockRepository)
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
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

    // MARK: - Tests de validation
    func testValidateCategoryEmpty() {
        // Arrange
        viewModel.category = ""
        viewModel.duration = 30
        viewModel.intensity = 5

        // Act
        let isValid = viewModel.validate()

        // Assert
        XCTAssertFalse(isValid, "La validation doit échouer si la catégorie est vide")
        XCTAssertEqual(viewModel.errorMessage, "La catégorie est obligatoire.", "Le message d'erreur doit être correct")
    }

    func testValidateDurationInvalid() {
        // Arrange
        viewModel.category = "Running"
        viewModel.duration = 0
        viewModel.intensity = 5

        // Act
        let isValid = viewModel.validate()

        // Assert
        XCTAssertFalse(isValid, "La validation doit échouer si la durée est <= 0")
        XCTAssertEqual(viewModel.errorMessage, "La durée doit être supérieure à 0.", "Le message d'erreur doit être correct")
    }

    func testValidateIntensityInvalid() {
        // Arrange
        viewModel.category = "Running"
        viewModel.duration = 30
        viewModel.intensity = 11

        // Act
        let isValid = viewModel.validate()

        // Assert
        XCTAssertFalse(isValid, "La validation doit échouer si l'intensité est < 0 ou > 10")
        XCTAssertEqual(viewModel.errorMessage, "L'intensité doit être comprise entre 0 et 10.", "Le message d'erreur doit être correct")
    }

    func testValidateSuccess() {
        // Arrange
        viewModel.category = "Running"
        viewModel.duration = 30
        viewModel.intensity = 5

        // Act
        let isValid = viewModel.validate()

        // Assert
        XCTAssertTrue(isValid, "La validation doit réussir si toutes les entrées sont valides")
        XCTAssertNil(viewModel.errorMessage, "Aucun message d'erreur ne doit être défini en cas de succès")
    }

    // MARK: - Tests d'ajout d'exercice
    func test_AddExercise_Success() {
        // Arrange
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
        mockRepository.shouldThrowError = true
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
