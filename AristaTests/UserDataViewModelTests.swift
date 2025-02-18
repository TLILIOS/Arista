//
//  UserDataViewModelTests.swift
//  AristaTests
//
//  Created by TLiLi Hamdi on 14/02/2025.
//
import XCTest
@testable import Arista
@MainActor
final class UserDataViewModelTests: XCTestCase {
    
    var viewModel: UserDataViewModel!
    var mockRepository: MockUserRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockUserRepository()
    }
    
    override func tearDown() {
        
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - Mock Repository
    class MockUserRepository: UserRepositoryProtocol {
        var user: User?
        var shouldThrowError = false
        
        func getUser() throws -> User? {
            if shouldThrowError {
                throw NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
            }
            return user
        }
    }
    
    func test_WhenNoUser_FetchUserData_ReturnsEmptyStrings() {
        // Arrange
       
        mockRepository.user = nil
        
        // Act
        viewModel = UserDataViewModel(userRepository: mockRepository)
        
        // Assert
        XCTAssertEqual(viewModel.firstName, "")
        XCTAssertEqual(viewModel.lastName, "")

    }
    
    func test_WhenUserExists_FetchUserData_ReturnsUserData() {
        // Arrange
       
        let context = PersistenceController(inMemory: true).container.viewContext
        let mockUser = User(context: context)
        mockUser.firstName = "John"
        mockUser.lastName = "Doe"
        try? context.save()
        mockRepository.user = mockUser
        
        // Act
        viewModel = UserDataViewModel(userRepository: mockRepository)
        
        // Assert
        XCTAssertEqual(viewModel.firstName, "John", "First name should be John")
        XCTAssertEqual(viewModel.lastName, "Doe", "Last name should be Doe")
    }
    
    func test_WhenRepositoryThrowsError_ShowsError() {
        // Arrange
        
        mockRepository.shouldThrowError = true
        
        // Act
        viewModel = UserDataViewModel(userRepository: mockRepository)
        
        // Assert
        XCTAssertTrue(viewModel.showError)
    }
}
