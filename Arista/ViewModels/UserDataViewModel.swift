//
//  UserDataViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation



class UserDataViewModel: ObservableObject, ErrorHandling {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var errorMessage: String?
    @Published var showError = false
    let userRepository: UserRepositoryProtocol
    init(userRepository: UserRepositoryProtocol = UserRepository()) {
        self.userRepository = userRepository
        fetchUserData()
    }
    
    private func fetchUserData() {
        do {
             let user = try UserRepository().getUser()
            
            firstName = user?.firstName ?? ""
            lastName = user?.lastName ?? ""
        } catch {
            handleError(error, operation: "Impossible de charger les données utilisateur")
        }
    }
}
