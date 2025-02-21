//
//  UserDataView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

//import SwiftUI
//
//struct UserDataView: View {
//    @ObservedObject var viewModel: UserDataViewModel
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Spacer()
//            Text("Hello")
//                .font(.largeTitle)
//            Text("\(viewModel.firstName) \(viewModel.lastName)")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .foregroundColor(.blue)
//                .padding()
//                .scaleEffect(1.2)
//                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: UUID())
//            Spacer()
//        }
//        .edgesIgnoringSafeArea(.all)
//    }
//}
//
//#Preview {
//    UserDataView(viewModel: UserDataViewModel())
//}
//
//  UserDataView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

//
//  UserDataView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct UserDataView: View {
    @ObservedObject var viewModel: UserDataViewModel
    @State private var profileAnimation = false
    @State private var textAnimation = false
    
    var body: some View {
        ZStack {
            // Arrière-plan dégradé
            LinearGradient(
                gradient: Gradient(colors: [Color(.systemIndigo), Color(.systemTeal)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Icône de profil animée
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.white.opacity(0.9))
                    .background(
                        Circle()
                            .fill(Material.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.2), radius: 10)
                    )
                    .scaleEffect(profileAnimation ? 1 : 0.5)
                    .opacity(profileAnimation ? 1 : 0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: profileAnimation)
                
                // Contenu textuel
                VStack(alignment: .center, spacing: 8) {
                    Text("Bonjour")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.8))
                        .transition(.opacity)
                    
                    Text("\(viewModel.firstName) \(viewModel.lastName)")
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, Color(.systemGray5)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .black.opacity(0.1), radius: 3, x: 1, y: 2)
                        .scaleEffect(textAnimation ? 1.05 : 0.95)
                        .animation(
                            .easeInOut(duration: 1.2)
                            .repeatForever(autoreverses: true),
                            value: textAnimation
                        )
                }
                .offset(y: profileAnimation ? 0 : 20)
                .opacity(textAnimation ? 1 : 0)
                .animation(.easeInOut(duration: 0.8).delay(0.2), value: textAnimation)
            }
            .padding()
        }
        .onAppear {
            profileAnimation = true
            textAnimation = true
        }
    }
}

#Preview {
    let mockViewModel = UserDataViewModel()
    mockViewModel.firstName = "Hamdi"
    mockViewModel.lastName = "Tlili"
    return UserDataView(viewModel: mockViewModel)
}
