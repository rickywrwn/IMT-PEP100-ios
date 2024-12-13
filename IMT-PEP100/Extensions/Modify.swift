//
//  Modify.swift
//  MEP
//
//  Created by Nathan Getachew on 5/19/24.
//

import SwiftUI

extension View {
    func modify<Content>(@ViewBuilder _ transform: (Self) -> Content) -> Content {
        transform(self)
    }
}
