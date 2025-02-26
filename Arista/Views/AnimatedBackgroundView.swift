//
//  AnimatedBackgroundView.swift
//  Arista
//
//  Created by TLiLi Hamdi on 26/02/2025.
//

import SwiftUI

import SwiftUI

struct AnimatedBackground: View {
    @State private var animateBackground = false

    var body: some View {
        AngularGradient(gradient: Gradient(colors: [.indigo, .purple, .cyan]), center: .topLeading)
            .ignoresSafeArea()
            .hueRotation(.degrees(animateBackground ? 45 : 0))
            .animation(.easeInOut(duration: 10).repeatForever(autoreverses: true), value: animateBackground)
            .onAppear {
                animateBackground = true
            }
    }
}

#Preview {
    AnimatedBackground()
}
