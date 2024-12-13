//
//  AvatarView.swift
//  MEP
//
//  Created by Nathan Getachew on 1/30/24.
//

import SwiftUI

struct AvatarView: View {
    var size : CGFloat = 70
    var body: some View {
        Image(systemName: "person.fill")
            .resizable()
            .scaledToFit()
            .frame(width: size , height: size)
            .foregroundColor(.white)
            .padding(size/2)
            .background(.avatarBackground)
            .clipShape(Circle())
    }
}

#Preview {
    AvatarView()
}
