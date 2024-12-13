//
//  GridCell.swift
//  MEP
//
//  Created by Nathan Getachew on 1/31/24.
//

import SwiftUI

extension View {
    func modifyCell(backgroundColor : Color = .accentColor, foregroundColor : Color = .black ) -> some View {
        modifier(CellModifier(backgroundColor: backgroundColor, foregroundColor: foregroundColor))
    }
}

struct CellModifier: ViewModifier {
    let backgroundColor : Color
    let foregroundColor: Color
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
    }
}
