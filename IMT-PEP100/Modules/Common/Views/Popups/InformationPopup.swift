//
//  InformationPopup.swift
//  MEP
//
//  Created by Nathan Getachew on 3/8/24.
//

import SwiftUI

struct InformationPopup: View {
let title : String
var backgroundColor : Color = .accentColor
let foregroundColor : Color = .white
    
    let child : AnyView
var confirmLabel : String = "confirm"
var onConfirm: () -> Void = {}
var body: some View {
    ZStack {
        
        Color.black
            .opacity(0.5)
            .edgesIgnoringSafeArea(.all)
            .ignoresSafeArea(.all)
            .onTapGesture {
                onConfirm()
            }
        VStack(spacing: 0){
            Text(LocalizedStringKey(title))
                .padding(.horizontal)
                .multilineTextAlignment(.center)
                .font(.title3)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity)
                .foregroundColor(foregroundColor)
                .background(backgroundColor)
            
            VStack(spacing: 24) {
                
                child
                
                HStack (spacing: 40){
                    PrimaryButton(label: confirmLabel, backgroundColor: backgroundColor){
                        onConfirm()
                    }
                }
            }
            .padding(24)
            //        .frame(maxWidth: .infinity)
        }
        .background(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(.black, lineWidth: 2)
        )
        .padding(24)
    }
     .presentationBackground(.clear)
    .ignoresSafeArea(.all)
}
}

#Preview {
    InformationPopup(title: "Hello", child: AnyView(Text("Hello")))
}
