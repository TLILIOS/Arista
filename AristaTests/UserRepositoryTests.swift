//
//  UserRepositoryTests.swift
//  AristaTests
//
//  Created by TLiLi Hamdi on 14/02/2025.
//


import XCTest
import CoreData
@testable import Arista

final class UserRepositoryTests: XCTestCase {

    // Supprime toutes les entités User dans le contexte
    private func emptyUserEntities(context: NSManagedObjectContext) {
        let fetchRequest = User.fetchRequest()
        let users = try! context.fetch(fetchRequest)
        for user in users {
            context.delete(user)
        }
        try! context.save()
    }

    // Crée un utilisateur dans la base temporaire
    private func createUserEntity(context: NSManagedObjectContext, firstName: String, lastName: String) {
        let user = User(context: context)
        user.firstName = firstName
        user.lastName = lastName
        try! context.save()
    }

    // TEST 1 : Quand la base est vide, getUser() retourne nil
    func test_WhenDatabaseIsEmpty_GetUser_ReturnsNil() throws {
        let persistenceController = PersistenceController(inMemory: true)
        let context = persistenceController.container.viewContext
        emptyUserEntities(context: context)

        let repository = UserRepository(viewContext: context)
        let user = try repository.getUser()

        XCTAssertNil(user)
    }

    // TEST 2 : Quand un utilisateur est ajouté, getUser() retourne cet utilisateur
    func test_WhenOneUserExists_GetUser_ReturnsUser() throws {
        let persistenceController = PersistenceController(inMemory: true)
        let context = persistenceController.container.viewContext
        emptyUserEntities(context: context)

        createUserEntity(context: context, firstName: "Hamdi", lastName: "TLiLi")

        let repository = UserRepository(viewContext: context)
        let user = try repository.getUser()

        XCTAssertNotNil(user)
        XCTAssertEqual(user?.firstName, "Hamdi")
        XCTAssertEqual(user?.lastName, "TLiLi")
    }

    // TEST 3 : Quand plusieurs utilisateurs existent, getUser() retourne le premier (non garanti sans tri)
    func test_WhenMultipleUsersExist_GetUser_ReturnsOneUser() throws {
        let persistenceController = PersistenceController(inMemory: true)
        let context = persistenceController.container.viewContext
        emptyUserEntities(context: context)

        createUserEntity(context: context, firstName: "Alice", lastName: "Smith")
        createUserEntity(context: context, firstName: "Bob", lastName: "Johnson")

        let repository = UserRepository(viewContext: context)
        let user = try repository.getUser()

        XCTAssertNotNil(user)
        // Vérifie que l'un des deux est retourné sans garantir l'ordre
        XCTAssertTrue(user?.firstName == "Alice" || user?.firstName == "Bob")
    }
}
