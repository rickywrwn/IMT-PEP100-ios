//
//  BreathingExerciseButton.swift
//  MEP
//
//  Created by Nathan Getachew on 2/6/24.
//

import SwiftUI

struct BreathingExerciseButton: View {
    let label: String
    var onTap: () -> Void
    var body: some View {
        Button {
            onTap()
        } label: {
            VStack(spacing: 8) {
                Text(LocalizedStringKey(label))
                    .font(.title2)
                Image("ArrowRight")
                    .resizable()
                    .scaledToFit()
            }
                .frame(maxWidth: .infinity)
                .padding()
                .padding(.vertical)
                .foregroundColor(.white)
                .background(.redAccent.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
        }
    }
}

#Preview {
    BreathingExerciseButton(label: ""){
        
    }
}
