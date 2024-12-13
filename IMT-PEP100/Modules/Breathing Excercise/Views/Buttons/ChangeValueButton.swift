//
//  ChangeCountButton.swift
//  MEP
//
//  Created by Nathan Getachew on 2/9/24.
//

import SwiftUI

enum ChangeType {
    case increment
    case decrement
}

struct ChangeValueButton: View {
    @Binding var value: Int
    let type: ChangeType
    let minValue: Int
    let maxValue: Int
    var step: Int = 1
    var body: some View {
        Button {
            switch type {
            case .increment:
                value = min(maxValue, value + step)
            case .decrement:
                value = max(minValue, value - step)
            }
        } label: {
            Image(systemName: "triangle.fill")
                .foregroundColor(.redAccent)
                .rotationEffect(type == .decrement ? .degrees(-90) :  .degrees(90))
        }
    }
}

#Preview {
    ChangeValueButton(
        value: .constant(2),
        type: ChangeType.decrement,
        minValue: 0,
        maxValue: 0)
}
