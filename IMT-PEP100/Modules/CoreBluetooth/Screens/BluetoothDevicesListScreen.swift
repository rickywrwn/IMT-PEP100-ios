//
//  BluetoothDevicesListScreen.swift
//  MEP
//
//  Created by Nathan Getachew on 2/27/24.
//


import SwiftUI

struct BluetoothDevicesListScreen: View {
    @EnvironmentObject var bleManager: CoreBluetoothViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            ZStack {
                if !bleManager.isSearching {
                    
                    if bleManager.foundPeripherals.isEmpty {
                        Text("No devices found")
                    } else {
                        VStack {
                            List(bleManager.foundPeripherals) { peripheral in
                                Button {
                                    bleManager.connectPeripheral(peripheral)
                                    dismiss()
                                } label: {
                                    Text(peripheral.name)
                                }
                            }
                        }
                    }
                } else {
                    Color.black.opacity(0.7)
                    .ignoresSafeArea(.all, edges: .all)
                    ProgressView()
                    .tint(.white)


                }
            }
            .onAppear{
                bleManager.startScan()
            }
            //                .navigationTitle("Select Device")
            .toolbar {
                ToolbarItem {
                    Button {
                        bleManager.startScan()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .tint(.black)
                    }
                }
                // cancel button
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        bleManager.stopScan()
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .tint(.black)
                    }
                }
            }
        }
    }
}

#Preview {
    BluetoothDevicesListScreen()
        .environmentObject(CoreBluetoothViewModel())
}
