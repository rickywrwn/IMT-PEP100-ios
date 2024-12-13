//
//  LungCapacityMeasurementScreen.swift
//  MEP
//
//  Created by Nathan Getachew on 2/1/24.
//

import SwiftUI

struct LungCapacityMeasurementScreen: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isSelected == %@", NSNumber(value: true)))
    var selectedUser: FetchedResults<User>
    
    @EnvironmentObject var viewModel: CoreBluetoothViewModel
    @EnvironmentObject var navStore: NavigationStore
    @State private var bluetoothNotConnected = false
    @State private var showHelp = false
    
    
    @State private var isMeasuring = false
    @State private var remainingTime: Int = 0
    @State var timer: Timer?
        
    @State private var measurementData: [MeasurementData] = []
    
    // MARK: - Computed arrays
    private var flowRateData: [MeasurementData] {
        measurementData.map { item in
            let flowRate = calculateFlowRate(for: item.value)
            return MeasurementData(date: item.date, value: flowRate)
        }
    }

    private var firstSecondData: [MeasurementData] {
       flowRateData.filter { item in
            let seconds = item.date.timeIntervalSince(flowRateData.first?.date ?? .now)
            return seconds <= 1.0
        } 
    }
    
    private var mid_50_percent: [MeasurementData]{
        flowRateData.filter { item in
            let seconds = item.date.timeIntervalSince(flowRateData.first?.date ?? .now)
            return seconds >= 1.75 && seconds <= 5.25
        }
    }
    
    private var measurementComplete: Bool {
        !isMeasuring && !measurementData.isEmpty
    }
    
    
    // MARK: - Computed vars
    private var fvc: Double {
        flowRateData.reduce(0) { $0 + ($1.value * 0.1) }
    }

    private var fev1: Double {
        firstSecondData.reduce(0) { $0 + ($1.value * 0.1) }
    }

    private var fev1_to_fvc_ratio: Double {
        fvc > 0 ? fev1 / fvc : 0
        
    }
    
    private var fef_25_to_75: Double {
        return !mid_50_percent.isEmpty ? mid_50_percent.reduce(0) { $0 + $1.value } / Double(mid_50_percent.count) : 0
    }
    
    private var pef: Double {
        flowRateData.compactMap{ $0.value }.max() ?? 0
    }
    
    private var mvv : Double {
        fev1 * 40
    }

    
    
    var body: some View {
        return VStack(spacing: 0 ){
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        if measurementData.isEmpty{
                            LungCapacityResultsChartPlaceHolder()
                        } else {
                            LungCapacityResultsChart(results: flowRateData)
                        }
                        
                        
                        Spacer()
                        
                        LungCapacityMeasurementTable(
                            user: selectedUser.first!,
                            fvc: fvc,
                            fev1: fev1,
                            fev1_to_fvc_ratio: fev1_to_fvc_ratio,
                            fef_25_to_75: fef_25_to_75,
                            pef: pef,
                            mvv: mvv
                            )
                        
                        Spacer()
                    }
                    .frame(height: geometry.size.height)
                }
                 
            }
            
            HStack(spacing: 4){
                GridRowButton(
                    title: "breathing-exercise",
                    backgroundColor: .greenAccent,
                    disabled: !viewModel.isConnected || isMeasuring || measurementComplete
                ){
                    navStore.path.removeLast(navStore.path.count)
                    navStore.path.append(Screens.chooseExercise)
                }
                
                GridRowButton(
                    title: "start",
                    backgroundColor: .greenAccent,
                    disabled: !viewModel.isConnected || isMeasuring || measurementComplete
                ){
                    if viewModel.isConnected {
                        // start measurement
                        viewModel.sendCommand(.startMeasurement)
                        remainingTime = 6
                        isMeasuring = true
                        
                    } else {
                        bluetoothNotConnected = true
                    }
                }
//                .disabled(!viewModel.isConnected || measurementComplete)
//                .disabled(true)
                
                GridRowButton(
                    title: "result",
                    backgroundColor: .greenAccent,
                    disabled: !viewModel.isConnected || !measurementComplete
                ){
                    do {
                        // Save the user's lung measurements
                        let lungMeasurement = LungMeasurement(context: moc)
                        if !measurementData.isEmpty {
                            measurementData.forEach { item in
                                let measurement = Measurement(context: moc)
                                measurement.value = item.value
                                measurement.date = item.date
                                lungMeasurement.addToMeasurements(measurement)
                            }
                        }
                        lungMeasurement.fvc = fvc
                        lungMeasurement.fev1 = fev1
                        lungMeasurement.fev1_to_fvc_ratio = fev1_to_fvc_ratio
                        lungMeasurement.fef_25_to_75 = fef_25_to_75
                        lungMeasurement.pef = pef
                        lungMeasurement.mvv = mvv
                        
                            
                            // Save the lung measurements to the user
                            selectedUser.first?.addToLungMeasurements(lungMeasurement)
                            try moc.save()
                            // Navigate to the respiratory measurement results screen
                            navStore.path.append(Screens.lungMeasurementResultsScreen(lungMeasurement.id ?? UUID()))
                            
                        } catch let error {
                            print("Error saving note: \(error)")
                        }
                    
                }
//                .disabled(!viewModel.isConnected || !measurementComplete)
            }
            .fixedSize(horizontal: false, vertical: true)
//            .padding([.horizontal, .bottom])
            .padding(.top, 4)
        }
        .padding()
        .onChange(of: viewModel.measurementData) { data in
                if !isMeasuring || data.isEmpty { return }
            // Start the timer when the first measurement is received
            if(timer == nil){
                timer = Timer.scheduledTimer(withTimeInterval: 6, repeats: false) { _ in
                    remainingTime = 0
                }
            }

                if remainingTime == 0 {
                    print("6 seconds done")
                    if(data.last?.value ?? 5 < 5 ){
                        viewModel.sendCommand(.stopMeasurement)
                        isMeasuring = false
                        timer = nil
                    }
                }
                measurementData = data
        }
        .onAppear {
            if !viewModel.isConnected {
                bluetoothNotConnected = true
            }
        }
        .onDisappear{
            // Stop the measurement and reset values
            isMeasuring = false
            viewModel.sendCommand(.stopMeasurement)
            measurementData = []
            remainingTime = 0
            timer?.invalidate()
            timer = nil

        }
        .toolbar {
            ToolbarItem {
                Button {
                    navStore.path.append(Screens.lungMeasurementResultsListScreen(selectedUser.first!.id ?? UUID()))
                } label: {
                    Image(systemName: "line.3.horizontal")
                }
            }
        }
        .navBar(
            title: "spirometry",
            showHelp: $showHelp,
            backgroundColor: .greenAccent)
        .fullScreenCover(isPresented: $showHelp) {
            InformationPopup(
                title: "help",
                backgroundColor: .greenAccent,
                child: AnyView(
                    
                    Text("lung-capacity-help")
                        .multilineTextAlignment(.leading)
                )) {
                    showHelp = false
                }
        }
        .fullScreenCover(isPresented: $bluetoothNotConnected) {
            InformationPopup(
                title: "notification",
                backgroundColor: .greenAccent,
                child: AnyView(
                    
                    Text("please-connect-to-bluetooth")
                        .multilineTextAlignment(.center)
                )) {
                    bluetoothNotConnected = false
                }
        }
    }
}

#Preview {
    NavigationView {
        LungCapacityMeasurementScreen()
            .environmentObject(CoreBluetoothViewModel())
    }
}
