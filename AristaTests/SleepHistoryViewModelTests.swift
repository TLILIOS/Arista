//
//  SleepHistoryViewModelTests.swift
//  AristaTests
//
//  Created by TLiLi Hamdi on 14/02/2025.
//
import XCTest
import Combine
@testable import Arista

final class SleepHistoryViewModelTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    override func tearDown() {
        cancellables.removeAll()
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
        let expectation = XCTestExpectation(description: "fetch empty list")
        
        // Act & Assert
        viewModel.$sleepSessions
            .sink { sessions in
                XCTAssertTrue(sessions.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_WhenRepositoryHasSessions_FetchSleepSessions_ReturnsList() {
        // Arrange
        let mockRepository = MockSleepRepository()
        let mockSession = Sleep(context: PersistenceController(inMemory: true).container.viewContext)
        mockSession.startDate = Date()
        mockRepository.sleepSessions = [mockSession]
        
        let viewModel = SleepHistoryViewModel(sleepRepository: mockRepository)
        let expectation = XCTestExpectation(description: "fetch sessions list")
        
        // Act & Assert
        viewModel.$sleepSessions
            .sink { sessions in
                XCTAssertFalse(sessions.isEmpty)
                XCTAssertEqual(sessions.count, 1)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_WhenRepositoryThrowsError_ShowsError() {
        // Arrange
        let mockRepository = MockSleepRepository()
        mockRepository.shouldThrowError = true
        let viewModel = SleepHistoryViewModel(sleepRepository: mockRepository)
        let expectation = XCTestExpectation(description: "show error")
        
        // Act & Assert
        viewModel.$showError
            .dropFirst()
            .sink { showError in
                if showError {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}
