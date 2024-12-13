//
//  SelectUserScreen.swift
//  MEP
//
//  Created by Nathan Getachew on 1/31/24.
//

import SwiftUI


struct SelectUserScreen: View {
    @Environment(\.dismiss) var dismiss
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \User.createdAt, ascending: false)])
    var users: FetchedResults<User>


    var body: some View {
        NavigationView {
            VStack {
                if users.isEmpty {
                    Text("No users found")
                } else {
                    List {
                        ForEach(users) { user in
                            UserTile(user: user)
                        }
                    }
                }
            }
            .toolbar {
                
                // cancel button
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .tint(.black)
                    }
                }
                ToolbarItem {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .tint(.black)
                    }
                }
            }
        }
    }
}



#Preview {
    SelectUserScreen()
}
