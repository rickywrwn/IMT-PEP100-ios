//
//  PrimaryButton.swift
//  MEP
//
//  Created by Nathan Getachew on 1/30/24.
//

import SwiftUI

struct PrimaryButton: View {
    let label : String
    var backgroundColor : Color = .accentColor
    var foregroundColor : Color = .white
    var onTap: () -> Void = {}

    var body: some View {
        Button {
            onTap()
        } label: {
            Text(LocalizedStringKey(label))
                .font(.footnote)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .foregroundColor(foregroundColor)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PrimaryButton(label: "confirm")
}
