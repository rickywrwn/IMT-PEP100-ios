//
//  BreathingExerciseSettingsButton.swift
//  MEP
//
//  Created by Nathan Getachew on 2/6/24.
//

import SwiftUI

struct BreathingExerciseSettingsButton: View {
    let label: String
    var onTap: () -> Void
    var body: some View {
        Button {
            onTap()
        } label: {
            Text(LocalizedStringKey(label))
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(.redAccent.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
}

#Preview {
    BreathingExerciseSettingsButton(label: ""){
        
    }
}
