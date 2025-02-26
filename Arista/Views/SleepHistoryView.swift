//
//  SleepHistoryView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct SleepHistoryView: View {
    @ObservedObject var viewModel: SleepHistoryViewModel
    @State private var animateBackground = false
    var body: some View {
        ZStack {
            // Arrière-plan animé
            AngularGradient(gradient: Gradient(colors: [.indigo, .purple, .cyan]), center: .topLeading)
                .ignoresSafeArea()
                .hueRotation(.degrees(animateBackground ? 45 : 0))
                .animation(.easeInOut(duration: 10).repeatForever(autoreverses: true), value: animateBackground)
            List(viewModel.sleepSessions) { session in
                HStack {
                    QualityIndicator(quality: Int(session.quality))
                        .padding()
                    VStack(alignment: .leading) {
                        Text("Début : \(String(describing: session.startDate?.formatted()))")
                        Text("Durée : \(session.duration/60) heures")
                    }
                }
            }
            .navigationTitle("Historique de Sommeil")
        }
    }
    
    struct QualityIndicator: View {
        let quality: Int
        
        var body: some View {
            ZStack {
                Circle()
                    .stroke(qualityColor(quality), lineWidth: 5)
                    .foregroundColor(qualityColor(quality))
                    .frame(width: 30, height: 30)
                Text("\(quality)")
                    .foregroundColor(qualityColor(quality))
            }
        }
        
        func qualityColor(_ quality: Int) -> Color {
            switch (10-quality) {
            case 0...3:
                return .green
            case 4...6:
                return .yellow
            case 7...10:
                return .red
            default:
                return .gray
            }
        }
    }
}
#Preview {
    SleepHistoryView(viewModel: SleepHistoryViewModel())
}
