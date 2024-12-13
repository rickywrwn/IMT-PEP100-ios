//
//  ConfirmationPopup.swift
//  MEP
//
//  Created by Nathan Getachew on 1/31/24.
//

import SwiftUI

struct UserDeletionConfirmationPopup: View {
    let label : String
    var backgroundColor : Color = .accentColor
    var foregroundColor : Color = .white
    var onConfirm: () -> Void = {}
    var onCancel: () -> Void = {}
    var body: some View {
        ZStack {
            
            Color.black
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .ignoresSafeArea(.all)
                .onTapGesture {
                                        onCancel()
                }
            VStack(spacing: 30) {
                
                Text(LocalizedStringKey(label))
                    .multilineTextAlignment(.center)
                
                HStack (spacing: 40){
                    DeleteUserButton(label: "yes", backgroundColor: .red){
                        onConfirm()
                    }
                    DeleteUserButton(label: "no"){
                        onCancel()
                    }
                }
            }
            .padding(24)
            //        .frame(maxWidth: .infinity)
            .background(.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(.black, lineWidth: 2)
            )
            .padding()
        }
         .presentationBackground(.clear)
        .ignoresSafeArea(.all)
    }
}



#Preview {
    UserDeletionConfirmationPopup(label: "sure-to-delete")
}
