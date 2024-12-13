//
//  UserTile.swift
//  MEP
//
//  Created by Nathan Getachew on 1/31/24.
//

import SwiftUI
import CoreData

struct UserTile: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @ObservedObject var user : User
    @State var isDeletionConfirmationPopupVisible = false
    var body: some View {
        HStack {
            AvatarView(size: 20)
            Text(user.name ?? "")
                .lineLimit(2)
            Spacer()
            
            SelectUserButton(label: "select", backgroundColor: Color(uiColor: user.isSelected ? .systemGray5 : .accent ), foregroundColor: user.isSelected ? .black : .white) {
                let request = User.fetchRequest()
                do {
                    let users = try moc.fetch(request)
                    for user in users {
                        if user != self.user {
                            user.isSelected = false
                        } else {
                            user.isSelected = true
                        }
                    }
                    try moc.save()
                } catch {
                    print("Error selecting user")
                }
            }
            
            
            SelectUserButton(label: "correction") {
            }
            .allowsHitTesting(false)
            .background {
                NavigationLink (destination: UserRegistrationScreen(user: user) ){
                    
                }
//                .opacity(0)
//                .buttonStyle(.plain)
            }
            
            SelectUserButton(label: "delete", backgroundColor: .error) {
                isDeletionConfirmationPopupVisible = true
            }
        }
        .fullScreenCover(isPresented: $isDeletionConfirmationPopupVisible) {
            UserDeletionConfirmationPopup(label: "sure-to-delete") {
                moc.delete(user)
                do {
                    try moc.save()
                } catch {
                    print("Error deleting user")
                }
                isDeletionConfirmationPopupVisible = false
            } onCancel: {
                isDeletionConfirmationPopupVisible = false
            }
        }
    }
}


