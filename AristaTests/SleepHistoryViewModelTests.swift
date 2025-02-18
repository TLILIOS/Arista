//
//  SleepHistoryViewModelTests.swift
//  AristaTests
//
//  Created by TLiLi Hamdi on 14/02/2025.
//
import XCTest
@testable import Arista
@MainActor
final class SleepHistoryViewModelTests: XCTestCase {
    
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    // MARK: - Mock Repository
    class MockSleepRepository: SleepRepositoryProtocol {
        var sleepSessions: [Sleep] = []
        var shouldThrowError = false
        
        func getSleepSessions() throws -> [Sleep] {
            if shouldThrowError {
                throw NSError(domain: "MockError", code: -1)
            }
            return sleepSessions
        }
    }
    
    func test_WhenNoSleepSessions_FetchSleepSessions_ReturnEmptyList() {
        // Arrange
        let mockRepository = MockSleepRepository()
        let viewModel = SleepHistoryViewModel(sleepRepository: mockRepository)
        
        
        // Act & Assert
        XCTAssertTrue(viewModel.sleepSessions.isEmpty)
    }
    
    func test_WhenRepositoryHasSessions_FetchSleepSessions_ReturnsList() {
        // Arrange
        let mockRepository = MockSleepRepository()
        let mockSession = Sleep(context: PersistenceController(inMemory: true).container.viewContext)
        mockSession.startDate = Date()
        mockRepository.sleepSessions = [mockSession]
        
        let viewModel = SleepHistoryViewModel(sleepRepository: mockRepository)
        
        
        // Act & Assert
        XCTAssertFalse(viewModel.sleepSessions.isEmpty)
        XCTAssertEqual(viewModel.sleepSessions.count, 1)
    }
    
    func test_WhenRepositoryThrowsError_ShowsError() {
        // Arrange
        let mockRepository = MockSleepRepository()
        mockRepository.shouldThrowError = true
        
        // Act
        let viewModel = SleepHistoryViewModel(sleepRepository: mockRepository)
        
        
        // Assert
        XCTAssertTrue(viewModel.showError)
    }
}
