//
//  SleepHistoryViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation

class SleepHistoryViewModel: ObservableObject, ErrorHandling {
    @Published var sleepSessions = [Sleep]()
    @Published var errorMessage: String?
    @Published var showError = false
    private let sleepRepository: SleepRepositoryProtocol
    init(sleepRepository: SleepRepositoryProtocol = SleepRepository()) {
        self.sleepRepository = sleepRepository
        fetchSleepSessions()
    }
    
    private func fetchSleepSessions() {
        do {
            let data = SleepRepository()
            sleepSessions = try data.getSleepSessions()
        } catch {
            handleError(error, operation: "Impossible de supprimer l'exercice")
        }
    }
}

