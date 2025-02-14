//
//  UserDataViewModelTests.swift
//  AristaTests
//
//  Created by TLiLi Hamdi on 14/02/2025.
//
import XCTest
import Combine
@testable import Arista

final class UserDataViewModelTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    // MARK: - Mock Repository
    class MockUserRepository: UserRepositoryProtocol {
        var user: User?
        var shouldThrowError = false
        
        func getUser() throws -> User? {
            if shouldThrowError {
                throw NSError(domain: "MockError", code: -1)
            }
            return user
        }
    }
    
    func test_WhenNoUser_FetchUserData_ReturnsEmptyStrings() {
        // Arrange
        let mockRepository = MockUserRepository()
        let viewModel = UserDataViewModel(userRepository: mockRepository)
        let expectation = XCTestExpectation(description: "fetch empty user data")
        
        // Act & Assert
        Publishers.CombineLatest(viewModel.$firstName, viewModel.$lastName)
            .sink { firstName, lastName in
                XCTAssertEqual(firstName, "")
                XCTAssertEqual(lastName, "")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_WhenUserExists_FetchUserData_ReturnsUserData() {
        // Arrange
        let mockRepository = MockUserRepository()
        let mockUser = User(context: PersistenceController(inMemory: true).container.viewContext)
        mockUser.firstName = "John"
        mockUser.lastName = "Doe"
        mockRepository.user = mockUser
        
        let viewModel = UserDataViewModel(userRepository: mockRepository)
        let expectation = XCTestExpectation(description: "fetch user data")
        
        // Act & Assert
        Publishers.CombineLatest(viewModel.$firstName, viewModel.$lastName)
            .sink { firstName, lastName in
                XCTAssertEqual(firstName, "John")
                XCTAssertEqual(lastName, "Doe")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_WhenRepositoryThrowsError_ShowsError() {
        // Arrange
        let mockRepository = MockUserRepository()
        mockRepository.shouldThrowError = true
        let viewModel = UserDataViewModel(userRepository: mockRepository)
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
