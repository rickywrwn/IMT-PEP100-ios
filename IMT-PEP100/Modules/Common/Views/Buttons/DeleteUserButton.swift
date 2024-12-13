//
//  DeleteUserButton.swift
//  MEP
//
//  Created by Nathan Getachew on 3/16/24.
//

import SwiftUI

struct DeleteUserButton: View {
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
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .foregroundColor(foregroundColor)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                
        }
        .buttonStyle(.plain)
    }
}
