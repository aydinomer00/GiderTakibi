//
//  LottieView.swift
//  GiderTakibi
//
//  Created by Omer Murat Aydin on 21.10.2024.
//

import SwiftUI
import Lottie

// The LottieView struct integrates Lottie animations into SwiftUI.
struct LottieView: UIViewRepresentable {
    var filename: String
    var loopMode: LottieLoopMode = .loop

    // Creates the UIView that hosts the Lottie animation.
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)

        // Initialize Lottie AnimationView.
        let animationView = LottieAnimationView(name: filename)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()

        // Setup Auto Layout constraints.
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
    }

    // Updates the UIView with new data if needed.
    func updateUIView(_ uiView: UIView, context: Context) {
        // Animation update logic can be added here if needed.
    }
}

// Preview provider for LottieView.
struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        LottieView(filename: "Animation10")
            .frame(width: 200, height: 200)
    }
}
