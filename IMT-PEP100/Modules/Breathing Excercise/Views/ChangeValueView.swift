//
//  ChangeValueView.swift
//  MEP
//
//  Created by Nathan Getachew on 2/11/24.
//

import SwiftUI

struct ChangeValueView: View {
    @Binding var value: Int
    let min: Int
    let max: Int
    var step: Int = 1
    var body: some View {
        HStack(spacing: 20) {
            ChangeValueButton(
                value: $value,
                type: .decrement,
                minValue: min,
                maxValue: max,
                step: step
            )
            
            Text("\(value)")
            
            ChangeValueButton(
                value: $value,
                type: .increment,
                minValue: min,
                maxValue: max,
                step: step
            )
        }
        .font(.title2)
    }
}

#Preview {
    ChangeValueView(value: .constant(0), min: 0, max: 0)
}
