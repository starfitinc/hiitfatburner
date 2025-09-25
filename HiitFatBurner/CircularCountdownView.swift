//
//  CircularCountdownView.swift
//  HiitFatBurner
//
//  Created by Starfit Inc on 05/04/25.
//

import SwiftUI
import Foundation

struct CircularCountdownView: View {
    var progress: Double
    var timeText: String
    var cycleText: String
    var isPaused: Bool // 👈 novo parâmetro
    var onTogglePause: () -> Void

    var body: some View {
        ZStack {
            // Círculo de fundo e progresso
            Circle()
                .stroke(lineWidth: 10)
                .foregroundColor(Color.gray.opacity(0.2))

            Circle()
                .trim(from: 0.0, to: CGFloat(progress))
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .foregroundColor(Color.orange)
                .rotationEffect(.degrees(-90))

            VStack(spacing: 8) {
                // Botão Play/Pause com base no estado
                Button(action: {
                    onTogglePause()
                }) {
                    Image(systemName: isPaused ? "play.fill" : "pause.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.white)
                }
                .frame(width: 30, height: 30)
                .background(Color.orange)
                .clipShape(Circle())

                Text(cycleText)
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top, 5)

                Text(timeText)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 5)
            }
        }
        .frame(width: 160, height: 160)
        .padding()
        .background(Color.black.opacity(0.7))
        .clipShape(Circle())
    }
}

