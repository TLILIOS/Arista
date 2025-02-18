//
//  SleepHistoryViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
@MainActor
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
            self.sleepSessions = try self.sleepRepository.getSleepSessions()
        } catch {
            self.handleError(error, operation: "Impossible de récupérer les sessions de sommeil")
        }
    }
}

