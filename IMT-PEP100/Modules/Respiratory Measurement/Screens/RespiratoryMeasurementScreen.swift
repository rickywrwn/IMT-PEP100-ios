//
//  RespiratoryMeasurementScreen.swift
//  MEP
//
//  Created by Nathan Getachew on 1/31/24.
//

import SwiftUI
import Charts

struct MockMeasurement: Identifiable{
    var id = UUID()
    var time: Int
    var capacity: Double
}

enum MeasurementType {
    case mip
    case mep
}


struct RespiratoryMeasurementScreen: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isSelected == %@", NSNumber(value: true)))
    var selectedUser: FetchedResults<User>
    
    @EnvironmentObject var navStore: NavigationStore
    @EnvironmentObject var viewModel: CoreBluetoothViewModel
    @AppStorage("connect-mouthpiece-info") private var connectMouthPieceInfoPresented = false
    @State private var bluetoothNotConnected = false
    @State private var selectionPresented = false
    
    @State private var help1 = false
    @State private var help2 = false
    @State private var help3 = false

    
    @State private var currentMeasurementType: MeasurementType?
    @State private var isMeasuring = false
    @State var timer: Timer?
    
    var results : [MeasurementData] {
        viewModel.measurementData
    }
    
    @State private var mipMeasurements: [[MeasurementData]] = []
    @State private var mepMeasurements: [[MeasurementData]] = []
    
  var maxMIPMeasurements: [Double] {
        mipMeasurements.map { $0.map { $0.value }.max() ?? 0 }
    }
    var maxMEPMeasurements: [Double] {
        mepMeasurements.map { $0.map { $0.value }.max() ?? 0 }
    }

    @State private var mipCount = 0
    @State private var mepCount = 0
    
    
    var maxMip: Double? {
        maxMIPMeasurements.compactMap { $0 }.max()
    }
    var maxMep: Double? {
        maxMEPMeasurements.compactMap { $0 }.max()
    }
    //MARK: - Age
    var mipAge: Int? {
        
        if let maxMip = maxMip {
            var age: Int
            if selectedUser.first!.gender == Gender.male.rawValue {
                age = Int(Double(120 - maxMip) / 0.41)
            } else {
                age = Int(Double(108 - maxMip) / 0.61)
            }
            return max(20, min(age, 100))
        }
        return nil
    }
    var mepAge: Int? {
        if let maxMep = maxMep{
            var age: Int
            if selectedUser.first!.gender == Gender.male.rawValue {
                age = Int(Double(174 - maxMep) / 0.83)
            } else {
                age = Int(Double(131 - maxMep) / 0.86)
            }
            return max(20, min(age, 100))
        }
        return nil
    }
    
    //MARK: - Measurement Complete
    var mipMeasurementComplete: Bool {
        mipCount == 3
    }
    var mepMeasurementComplete: Bool {
       mepCount == 3
    }
    var measurementComplete: Bool {
        mipMeasurementComplete && mepMeasurementComplete
    }
    
    //MARK: - Reproducibility
    var mipReproducibility: Bool? {
        let sorted = maxMIPMeasurements.sorted()
        if sorted.count >= 2 {
            for i in 1..<sorted.count {
                let next = sorted[i]
                let curr = sorted[i-1]
                if next <= (curr * 1.1) && next >= (curr * 0.9){
                    return true
                }
            }
return false
        }
        return nil
    }
    
    var mepReproducibility: Bool? {
        if maxMEPMeasurements.count >= 2 {
            let sorted = maxMEPMeasurements.sorted()
            for i in 1..<sorted.count {
                let next = sorted[i]
                let curr = sorted[i-1]
                if next <= (curr * 1.1) && next >= (curr * 0.9){
                    return true
                }
            }
            return false
        }
        return nil
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        if mipMeasurements.isEmpty && mepMeasurements.isEmpty {
                            RespiratoryResultsChartPlaceHolder()
                        } else {
                            RespiratoryResultsChart(
                                mipMeasurements: mipMeasurements,
                                mepMeasurements: mepMeasurements
                            )
                        }
                        
                        Spacer()
                        Grid(alignment: .center) {
                            GridRow {
                                HStack {
                                    Text("")
                                    Spacer()
                                }
                                HStack {
                                    Spacer()
                                    //                        RadioButton(isSelected: .constant(true))
                                    Text("MIP")
                                        .foregroundColor(.orange)
                                        .font(.title2)
                                        .bold()
                                    
                                    Spacer()
                                }
                                HStack {
                                    Spacer()
                                    //                        RadioButton(isSelected: .constant(true))
                                    Text("MEP") .foregroundColor(.accent)
                                        .font(.title2)
                                        .bold()
                                    Spacer()
                                }
                            }
                            GridRow {
                                Text("1st")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.accent)
                                
                                Text(maxMIPMeasurements[safe: 0] != nil ? "\(maxMIPMeasurements[safe: 0] ?? 0, specifier: "%.2f")" : "")
                                    .font(.title3)
                                
                                Text(maxMEPMeasurements[safe: 0] != nil ? "\(maxMEPMeasurements[safe: 0] ?? 0, specifier: "%.2f")" : "")
                                    .font(.title3)
                                
                            }
                            GridRow {
                                Text("2nd")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.accent)
                                
                                Text(maxMIPMeasurements[safe: 1] != nil ? "\(maxMIPMeasurements[safe: 1] ?? 0, specifier: "%.2f")" : "")
                                    .font(.title3)
                                
                                Text(maxMEPMeasurements[safe: 1] != nil ? "\(maxMEPMeasurements[safe: 1] ?? 0, specifier: "%.2f")" : "")
                                    .font(.title3)
                                
                            }
                            GridRow {
                                Text("3rd")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.accent)
                                
                                Text(maxMIPMeasurements[safe: 2] != nil ? "\(maxMIPMeasurements[safe: 2] ?? 0, specifier: "%.2f")" : "")
                                    .font(.title3)
                                
                                Text(maxMEPMeasurements[safe: 2] != nil ? "\(maxMEPMeasurements[safe: 2] ?? 0, specifier: "%.2f")" : "")
                                    .font(.title3)
                            }
                            GridRow {
                                HStack {
                                    Text("Age").font(.title2)
                                        .bold()
                                        .foregroundColor(.accent)
                                    Button {
                                        help2 = true
                                    } label: {
                                        Image(systemName: "questionmark")
                                            .padding(.horizontal,3)
                                            .padding(.vertical,3)
                                            .background(.accent)
                                            .foregroundColor(.white)
                                            .cornerRadius(4)
                                            .font(.caption2)
                                    }
                                }
                                Text(mipAge != nil ? "\(mipAge ?? 0)" : "")
                                    .font(.title3)
                                Text(mepAge != nil ? "\(mepAge ?? 0)" : "")
                                    .font(.title3)
                            }
                            
                            
                        }
                        Spacer()
                        Grid(horizontalSpacing: 0) {
                            GridRow {
                               HStack {
                                Text("reproducibility")
                                   Button {
                                       help3 = true
                                   } label: {
                                       Image(systemName: "questionmark")
                                           .padding(.horizontal,3)
                                           .padding(.vertical,3)
                                           .background(.accent)
                                           .foregroundColor(.white)
                                           .cornerRadius(4)
                                           .font(.caption2)
                                   }
                            }
                                    .modifyCell(backgroundColor: .gray, foregroundColor: .white)
                                Text("MIP")
                                    .modifyCell(backgroundColor: .gray,  foregroundColor: .white)
                                Text("MEP")
                                    .modifyCell(backgroundColor: .gray,  foregroundColor: .white)
                            }
                            
                            .fixedSize(horizontal: false, vertical: true)
                            
                            row1
                            row2
                        }
                        
                        Spacer()
                        
                        
                        
                        //            .lineLimit(1)
                        
                    }
                    .frame(height: geometry.size.height)
                }
                
            }
//        .padding()
            
            HStack(spacing: 4) {
                GridRowButton(title: "breathing-exercise"){
                    navStore.path.removeLast(navStore.path.count)
                    navStore.path.append(Screens.chooseExercise)
                }
                .disabled(!viewModel.isConnected || isMeasuring || measurementComplete)
                GridRowButton(title: "start"){
                    if viewModel.isConnected {
                        selectionPresented = true
                    } else {
                        bluetoothNotConnected = true
                    }
                }
                .disabled(!viewModel.isConnected || isMeasuring || measurementComplete)
                
                GridRowButton(title: "result"){
                    do {
                        // Save the user's respiratory measurements
                        let respiratoryMeasurement = RespiratoryMeasurement(context: moc)
                        respiratoryMeasurement.mipReproducibility = mipReproducibility ?? false
                        respiratoryMeasurement.mepReproducibility = mepReproducibility ?? false
                        if let maxMip = maxMip{
                            respiratoryMeasurement.maxMIP = maxMip
                        }
                        if let maxMep = maxMep{
                            respiratoryMeasurement.maxMEP = maxMep
                        }
                        if let mipAge = mipAge{
                            respiratoryMeasurement.mipAge = Int16(mipAge)
                        }
                        if let mepAge = mepAge{
                            respiratoryMeasurement.mepAge = Int16(mepAge)
                        }
                        
                        // Save the MIP measurements
                        if !mipMeasurements.isEmpty {
                            mipMeasurements.forEach { measurement in
                                let mipMeasurement = MIPMeasurement(context: moc)
                                measurement.forEach { item in
                                    let mip = Measurement(context: moc)
                                    mip.value = item.value
                                    mip.date = item.date
                                    mipMeasurement.addToMeasurements(mip)
                                }
                                respiratoryMeasurement.addToMipMeasurements(mipMeasurement)
                            }
                        }
                        
                        // Save the MEP measurements
                        if !mepMeasurements.isEmpty {
                            mepMeasurements.forEach { measurement in
                                let mepMeasurement = MEPMeasurement(context: moc)
                                measurement.forEach { item in
                                    let mep = Measurement(context: moc)
                                    mep.value = item.value
                                    mep.date = item.date
                                    mepMeasurement.addToMeasurements(mep)
                                }
                                respiratoryMeasurement.addToMepMeasurements(mepMeasurement)
                            }
                        }
                        
                        // Save the respiratory measurements to the user
                        selectedUser.first?.addToRespiratoryMeasurements(respiratoryMeasurement)
                        try moc.save()
                        // Navigate to the respiratory measurement results screen
                        navStore.path.append(Screens.respiratoryMeasurementResultsScreen(respiratoryMeasurement.id ?? UUID()))
                        
                    } catch let error {
                        print("Error saving note: \(error)")
                    }
                    
                }
                .disabled(!viewModel.isConnected || !measurementComplete)
            }
            .fixedSize(horizontal: false, vertical: true)
//            .padding([.horizontal, .bottom])
            .padding(.top, 4)
    }
        .padding()
        .onChange(of: isMeasuring) { measuring in
            if !measuring {
                if currentMeasurementType == .mip {
                    mipCount += 1
                } else if currentMeasurementType == .mep {
                    mepCount += 1
                }
            }
        }
        .onChange(of: viewModel.measurementData) { data in
            if !isMeasuring || data.isEmpty { return }
            // Start the timer when the first measurement is received
            if(timer == nil){
                timer = Timer.scheduledTimer(withTimeInterval: 7.2, repeats: false) { _ in
                // Stop the measurement after 7.2 seconds
                    viewModel.sendCommand(.stopMeasurement)
                    isMeasuring = false
                    timer = nil
                }
            }
            
            if currentMeasurementType == .mip {
                if mipMeasurements[safe: mipCount] == nil {
                    mipMeasurements.append(data)
                } else {
                    mipMeasurements[mipCount] = data
                }
                
            } else if currentMeasurementType == .mep {
                if mepMeasurements[safe: mepCount] == nil {
                    mepMeasurements.append(data)
                } else {
                    mepMeasurements[mepCount] = data
                }
            }
            
        }
        .onAppear {
            if !viewModel.isConnected {
                bluetoothNotConnected = true
            }
        }
        .onDisappear{
            // Stop the measurement and reset values
            currentMeasurementType = nil
            isMeasuring = false
            timer?.invalidate()
            timer = nil
            mipCount = 0
            mepCount = 0
            viewModel.sendCommand(.stopMeasurement)
            mipMeasurements = []
            mepMeasurements = []
            
        }
        .toolbar {
            ToolbarItem {
                Button {
                    navStore.path.append(Screens.respiratoryMeasurementResultsListScreen(selectedUser.first!.id ?? UUID()))
                } label: {
                    Image(systemName: "line.3.horizontal")
                }
            }
        }
        .navBar(
            title: "respiratory-measurement",
            showHelp: $help1
        )
        .fullScreenCover(isPresented: $selectionPresented) {
            InformationPopup(
                title: "choose",
                child: AnyView(
                    HStack(spacing: 12) {
                        Button {
                            // Start the MIP measurement
                            currentMeasurementType = .mip
                            viewModel.sendCommand(.startMeasurement)
                            isMeasuring = true
                            selectionPresented = false
                        } label: {
                            VStack {
                                Text("MIP")
                                    .font(.title)
                                Text("mip-measurement")
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.orange)
                            .foregroundColor(.white)
                        }
                        .disabled(mipMeasurementComplete)
                        Button {
                            // Start the MEP measurement
                            currentMeasurementType = .mep
                            viewModel.sendCommand(.startMeasurement)
                            isMeasuring = true
                            selectionPresented = false
                            
                        } label: {
                            VStack {
                                Text("MEP")
                                    .font(.title)
                                Text("mep-measurement")
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.accent)
                            .foregroundColor(.white)
                        }
                        .disabled(mepMeasurementComplete)
                    }
                ),
                confirmLabel: "cancel"
            ) {
                selectionPresented = false
            }
        }
        .fullScreenCover(isPresented: $bluetoothNotConnected) {
            InformationPopup(
                title: "notification",
                child: AnyView(
                    
                    Text("please-connect-to-bluetooth")
                        .multilineTextAlignment(.center)
                )) {
                    bluetoothNotConnected = false
                }
        }
        .fullScreenCover(isPresented: Binding<Bool> (
            get: {!connectMouthPieceInfoPresented},
            set: {connectMouthPieceInfoPresented = !$0}
        )) {
            InformationPopup(
                title: "notification",
                child: AnyView(
                    HStack {
                        Text("connect-mouthpiece-info")
                            .multilineTextAlignment(.leading)
                        Spacer()
                    })) {
                        connectMouthPieceInfoPresented = true
                    }
        }
        .fullScreenCover(isPresented: $help1) {
            InformationPopup(
                title: "glossary",
                child: AnyView(
                    
                    Text("MIP: Maximal inspiratory pressure (최대흡기압, 들숨)\nMEP: Maximal expiratory pressure (최대호기압, 날숨)")
                        .multilineTextAlignment(.center)
                )) {
                    help1 = false
                }
        }
        .fullScreenCover(isPresented: $help2) {
            InformationPopup(
                title: "glossary",
                child: AnyView(
                    
                    Text("MIP, MEP 호흡근 나이")
                        .multilineTextAlignment(.center)
                )) {
                    help2 = false
                }
        }
        
        .fullScreenCover(isPresented: $help3) {
            InformationPopup(
                title: "재현성이란?",
                child: AnyView(
                    
                    Text("결과의 정확성을 나타내는 지표로, 수치가 큰 두 가지 값이 일정 범위(10%) 이내에 들어오면 결과가 믿을만하다는 뜻입니다.")
                        .multilineTextAlignment(.leading)
                )) {
                    help3 = false
                }
        }
    }
    
    var row1 : some View {
        GridRow {
            Text("YES")
            RadioButton(isSelected: .constant(mipReproducibility ?? false ))
            RadioButton(isSelected: .constant(mepReproducibility ?? false))
        }
    }
    var row2 : some View {
        GridRow {
            Text("NO")
            RadioButton(isSelected: .constant(!(mipReproducibility ?? true)))
            RadioButton(isSelected: .constant(!(mepReproducibility ?? true)))
        }
    }
}

#Preview {
    NavigationView {
        RespiratoryMeasurementScreen()
            .environmentObject(CoreBluetoothViewModel())
            .environment(\.locale, Locale(identifier: "en"))
    }
    
}
