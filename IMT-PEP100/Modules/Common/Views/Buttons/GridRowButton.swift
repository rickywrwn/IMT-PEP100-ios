//
//  GridRowButton.swift
//  MEP
//
//  Created by Nathan Getachew on 3/17/24.
//

import SwiftUI

struct GridRowButton: View {
    let title: String
    var backgroundColor: Color = .accentColor
    var foregroundColor: Color = .white
    var disabled: Bool = false
    let onTap: () -> Void

    var body: some View {
        Button{
            onTap()
        } label: {
            Text(LocalizedStringKey(title))
//                .lineLimit(1)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical)
                .background(disabled ? .gray : backgroundColor)
                .foregroundColor(foregroundColor)
                
        }
        .disabled(disabled)
    }
}

