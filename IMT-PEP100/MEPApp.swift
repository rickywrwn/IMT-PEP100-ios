//
//  MEPApp.swift
//  MEP
//
//  Created by Nathan Getachew on 1/29/24.
//

import SwiftUI

@main
struct MEPApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var bleManager =  CoreBluetoothViewModel()
    var body: some Scene {
        WindowGroup {
//            RootView {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(bleManager)
                .preferredColorScheme(.light)
//        }
        }
    }
}
