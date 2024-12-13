//
//  SelectedProfileView.swift
//  MEP
//
//  Created by Nathan Getachew on 5/5/24.
//

import SwiftUI

struct SelectedProfileView: View {
    var selectedUser: User?
    var body: some View {
        HStack(spacing: 2) {
            VStack( alignment: .trailing, spacing: 0) {
                Text(selectedUser?.name ?? "")
                    .font(.caption2)
                Text((selectedUser?.birthDate ?? .now)
                    .formatted(date: .numeric, time: .omitted))
                .font(.caption2)
            }
            
            AvatarView(size: 16)
        }
    }
}
