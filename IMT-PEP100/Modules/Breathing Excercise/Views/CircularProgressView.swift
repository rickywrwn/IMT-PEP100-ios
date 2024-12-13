//
//  CircularProgressView.swift
//  MEP
//
//  Created by Nathan Getachew on 2/7/24.
//

import SwiftUI


struct CircularProgressView: View {
     var progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.gray.opacity(0.5),
                    lineWidth: 16
                )
            Circle()
                .trim(from: 0, to:  progress )
                .stroke(
                    Color.redAccent,
                    style: StrokeStyle(
                        lineWidth: 16,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)

        }
    }
}

#Preview {
    CircularProgressView(progress: 0.9)
}
