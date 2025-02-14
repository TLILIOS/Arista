
//  SleepRepositoryTests.swift
//  AristaTests
//
//  Created by TLiLi Hamdi on 12/02/2025.
//

import XCTest
import CoreData
@testable import Arista

final class SleepRepositoryTests: XCTestCase {
    
    // Supprime toutes les entités Sleep
    private func emptySleepEntities(context: NSManagedObjectContext) {
        let fetchRequest = Sleep.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        for sleep in objects {
            context.delete(sleep)
        }
        try! context.save()
    }

    // Ajoute une session de sommeil
    private func addSleepSession(context: NSManagedObjectContext, startDate: Date, endDate: Date, duration: Int) {
        let newSleep = Sleep(context: context)
        newSleep.startDate = startDate
        newSleep.duration = Int64(duration)
        try! context.save()
    }

    // TEST 1 : Base vide -> Retourne une liste vide
    func test_WhenNoSleepSessionInDatabase_GetSleepSessions_ReturnsEmptyList() throws {
        let persistenceController = PersistenceController(inMemory: true)
        let context = persistenceController.container.viewContext
        emptySleepEntities(context: context)

        let repository = SleepRepository(viewContext: context)
        let sessions = try repository.getSleepSessions()

        XCTAssertTrue(sessions.isEmpty)
    }

    // TEST 2 : Ajout d’une session -> Retourne une liste avec la session ajoutée
    func test_WhenAddingOneSleepSession_GetSleepSessions_ReturnsTheSession() throws {
        let persistenceController = PersistenceController(inMemory: true)
        let context = persistenceController.container.viewContext
        emptySleepEntities(context: context)

        let startDate = Date()
        let endDate = Date().addingTimeInterval(3600)
        let duration = 60

        addSleepSession(context: context, startDate: startDate, endDate: endDate, duration: duration)

        let repository = SleepRepository(viewContext: context)
        let sessions = try repository.getSleepSessions()

        XCTAssertEqual(sessions.count, 1)
        XCTAssertEqual(sessions.first?.startDate, startDate)
        XCTAssertEqual(sessions.first?.duration, Int64(duration))
    }

    // TEST 3 : Ajout de plusieurs sessions -> Vérifie l’ordre récent -> ancien
    func test_WhenAddingMultipleSleepSessions_GetSleepSessions_ReturnsSessionsInCorrectOrder() throws {
        let persistenceController = PersistenceController(inMemory: true)
        let context = persistenceController.container.viewContext
        emptySleepEntities(context: context)

        let date1 = Date()
        let date2 = Date(timeIntervalSinceNow: -(60 * 60 * 24))
        let date3 = Date(timeIntervalSinceNow: -(60 * 60 * 24 * 2))

        addSleepSession(context: context, startDate: date1, endDate: date1.addingTimeInterval(3600), duration: 60)
        addSleepSession(context: context, startDate: date2, endDate: date2.addingTimeInterval(7200), duration: 120)
        addSleepSession(context: context, startDate: date3, endDate: date3.addingTimeInterval(5400), duration: 90)

        let repository = SleepRepository(viewContext: context)
        let sessions = try repository.getSleepSessions()

        XCTAssertEqual(sessions.count, 3)
        XCTAssertEqual(sessions[0].startDate, date1)
        XCTAssertEqual(sessions[1].startDate, date2)
        XCTAssertEqual(sessions[2].startDate, date3)
    }
}
