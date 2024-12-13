//
//  FullScreenPopUp.swift
//  MEP
//
//  Created by Nathan Getachew on 1/31/24.
//

import SwiftUI


extension View {
    func fullScreenPopup<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder popupContent: @escaping () -> Content
    ) -> some View {
        modifier(FullScreenPopup<Content>(isPresented: isPresented, popupContent: popupContent))
    }
}

struct FullScreenPopup<PopupContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    var  popupContent: () -> PopupContent
    
    func body(content: Content) -> some View {

        content
            .fullScreenCover(isPresented: $isPresented) {
                popupContent()
            }
    }
}
