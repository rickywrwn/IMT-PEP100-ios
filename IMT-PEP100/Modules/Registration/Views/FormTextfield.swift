//
//  FormTextfield.swift
//  MEP
//
//  Created by Nathan Getachew on 1/30/24.
//

import SwiftUI

struct FormTextfield: View {
    let placeHolder : String
    var text: Binding<String>
    @FocusState private var isFocused: Bool
    var body: some View {
        TextField(LocalizedStringKey(placeHolder), text: text)
            .focused($isFocused)
            .padding()
            .multilineTextAlignment(.center)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.black, lineWidth: 1)
            )
            .onTapGesture {
                isFocused = true
            }
        
        
    }
}


struct FormTextfieldPlaceHolder: View {
    let placeHolder : String
    var body: some View {
        Text(LocalizedStringKey(placeHolder))
            .frame(maxWidth: .infinity)
            .padding()
            .multilineTextAlignment(.center)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.black, lineWidth: 1)
                
            )        
        
    }
}

#Preview {
    FormTextfield(placeHolder: "",text: .constant(""))
}
