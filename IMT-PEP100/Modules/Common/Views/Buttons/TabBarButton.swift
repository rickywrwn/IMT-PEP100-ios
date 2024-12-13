//
//  TabBarButton.swift
//  MEP
//
//  Created by Nathan Getachew on 3/10/24.
//

import SwiftUI

struct TabBarButton: View {
    @EnvironmentObject var navStore : NavigationStore
    let tab: Tabs
    var isUserSelected: Bool = false
    @State private var help = false
    var body: some View {
        Button {
            if !isUserSelected {
                help = true
            } else {
                navStore.path.append(tab.screen)
            }
        } label: {
            Text(LocalizedStringKey(tab.title))
                .font(.subheadline)
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
        }
        .fullScreenCover(isPresented: $help) {
            InformationPopup(
                title: "notification",
                child: AnyView(
                    
                    Text("register-first")
                        .multilineTextAlignment(.leading)
                )) {
                    help = false
                }
        }
    }
    
}
