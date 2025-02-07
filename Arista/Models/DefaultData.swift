//
//  DefaultData.swift
//  Arista
//
//  Created by TLiLi Hamdi on 03/02/2025.
//

import Foundation
import CoreData
struct DefaultData {
    let viewContext: NSManagedObjectContext
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    func apply() throws {
        let userRepository = UserRepository(viewContext: viewContext)
        let sleepRepository = SleepRepository(viewContext: viewContext)
        if (try? userRepository.getUser()) == nil {
            let initialUser = User(context: viewContext)
            initialUser.firstName = "Hamdi"
            initialUser.lastName = "Tlili"
            
            if try sleepRepository.getSleepSessions().isEmpty {
                let sleep1 = Sleep(context: viewContext)
                let sleep2 = Sleep(context: viewContext)
                let sleep3 = Sleep(context: viewContext)
                let sleep4 = Sleep(context: viewContext)
                let sleep5 = Sleep(context: viewContext)
                
                let timeIntervalForADay: TimeInterval = 60 * 60 * 24
                
                sleep1.duration = (0...900).randomElement()!
                sleep1.quality = (0...10).randomElement()!
                sleep1.startDate = Date(timeIntervalSinceNow: timeIntervalForADay*5)
                sleep1.user = initialUser
                
                sleep2.duration = (0...900).randomElement()!
                sleep2.quality = (0...10).randomElement()!
                sleep2.startDate = Date(timeIntervalSinceNow: timeIntervalForADay*4)
                sleep2.user = initialUser
                
                sleep3.duration = (0...900).randomElement()!
                sleep3.quality = (0...10).randomElement()!
                sleep3.startDate = Date(timeIntervalSinceNow: timeIntervalForADay*3)
                sleep3.user = initialUser
                
                sleep4.duration = (0...900).randomElement()!
                sleep4.quality = (0...10).randomElement()!
                sleep4.startDate = Date(timeIntervalSinceNow: timeIntervalForADay*2)
                sleep4.user = initialUser
                
                sleep5.duration = (0...900).randomElement()!
                sleep5.quality = (0...10).randomElement()!
                sleep5.startDate = Date(timeIntervalSinceNow: timeIntervalForADay)
                sleep5.user = initialUser
            }
            
            try? viewContext.save()
        }
        
    }
}
