//
//  FormLabel.swift
//  MEP
//
//  Created by Nathan Getachew on 1/31/24.
//

import SwiftUI

struct FormLabel: View {
    let label: String
    var isRequired: Bool = true
    var body: some View {
        HStack(spacing: 2) {
            Text(LocalizedStringKey(label))
            if isRequired {
                Text("*")
                    .font(.largeTitle)
                    .foregroundStyle(.error)
            }
        }
    }
}

#Preview {
    FormLabel(label: "name")
}
