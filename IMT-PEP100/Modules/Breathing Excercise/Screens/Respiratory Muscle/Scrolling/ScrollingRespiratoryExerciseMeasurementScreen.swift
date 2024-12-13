//
//  ScrollingRespiratoryExerciseMeasurementScreen.swift
//  MEP
//
//  Created by Nathan Getachew on 5/19/24.
//

import SwiftUI
import CoreData

@available(iOS 17.0, *)
struct ScrollingRespiratoryExerciseMeasurementScreen: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var viewModel: CoreBluetoothViewModel
    @EnvironmentObject var navStore: NavigationStore
    
    @State  var pressureRatioMIP: Int = Ints.defaultPressureRatioMIP
    @State  var pressureRatioMEP: Int = Ints.defaultPressureRatioMEP
    @State  var timePerSectionMIP: Double = Double(Ints.defaultTimePerSectionMIP)
    @State  var timePerSectionMEP: Double = Double(Ints.defaultTimePerSectionMEP)
    @State  var restTime: Double = Double(Ints.defaultRestTime)
    @State  var numberOfSets: Int = Ints.defaultNumberOfSets
    
    
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isSelected == %@", NSNumber(value: true)))
    var selectedUser: FetchedResults<User>
    
    let measurementsPerSecond = 10
    
    //MARK: - Properties
    @State private var isHelpPresented = false
    @State private var bluetoothNotConnected = false
    @State private var isMeasuring = false
    //MARK: -
    //    @State private var measurementData: [MeasurementData] = []
    
    // array of length timePerSectionMIP
    @State private var mipCount = 0
    @State var accurateMipMeasurementsCount: Int = 0
    @State private var mipMeasurements: [[MeasurementData]] = []
    var maxMipMeasurements: [Double] {
        mipMeasurements.map { $0.map { $0.value }.max() ?? 0 }
    }
    var maxMip: Double {
        maxMipMeasurements.max() ?? 0
    }
    
    @State private var mepCount = 0
    @State private var mepMeasurements: [[MeasurementData]] = []
    @State  var accurateMepMeasurementsCount: Int = 0
    var maxMepMeasurements: [Double] {
        mepMeasurements.map { $0.map { $0.value }.max() ?? 0 }
    }
    var maxMep: Double {
        maxMepMeasurements.max() ?? 0
    }
    
    @State private var setCount = 0
    @State private var remainingTime:Double  = 0
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .default).autoconnect()
    
    var sectionTime: Double {
        timePerSectionMEP + restTime + timePerSectionMIP +  restTime
    }
    var totalTime : Double {
        Double(numberOfSets) * sectionTime
    }
    
    var elapsedTime: Double {
        totalTime - remainingTime
    }
    
    var elapsedSectionTime: Double {
        return elapsedTime - ( Double(setCount) *  sectionTime)
    }
    
    var totalProgress: Double {
        elapsedTime / totalTime
    }
    
    @State var measurements: [Double] = []
    
//    @State var startMock : Bool = false
//    @State var mockMeasurementData: [MeasurementData] = []
    
    
    var body: some View {

        VStack {
            
            Spacer()
            
            HStack {
                ZStack {
                    CircularProgressView(progress: Double(accuracy) / 100)
                    Text("\(accuracy)%")
                }
                .padding()
                
                ZStack {
                    let minutes = Int(elapsedTime) / 60
                    let seconds = Int(elapsedTime) % 60

                    
                    CircularProgressView(progress: !isMeasuring ? 0 : totalProgress)
                    
                    if !isMeasuring {
                        Text("00: 00")
                    } else {
                        
                        Text(
                            String(format: "%02i", minutes) +
                            " : " +
                            String(format: "%02i", seconds)
                        )
                    }
                }
                .padding()
            }
            .padding(32)
            .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            ZStack(alignment: .center) {
                
                ScrollingPredictedRespiratoryChart(
                    mipTime: Int(timePerSectionMIP),
                    mepTime: Int(timePerSectionMEP),
                    restTime: Int(restTime),
                    numberOfSets: numberOfSets,
                    measurementsPerSecond: measurementsPerSecond,
                    predMIP: adjustedMIP,
                    predMEP: adjustedMEP,
                    maxMIP: max(adjustedMIP, Int(maxMip)),
                    maxMEP: max(adjustedMEP, Int(maxMep)),
//                    maxMIP: adjustedMIP,
//                    maxMEP: adjustedMEP,
                    progress: isMeasuring ? totalProgress : 0
                        
                )
//                if isMeasuring {
                    ScrollingRespiratoryMuscleMovementChart(
                        measurements: measurements,
                        maxMIP: max(adjustedMIP, Int(maxMip)),
                        maxMEP: max(adjustedMEP, Int(maxMep)),
                        mipTime: Int(timePerSectionMIP),
                        mepTime: Int(timePerSectionMEP),
                        restTime: Int(restTime),
                        numberOfSets: numberOfSets,
                        measurementsPerSecond: measurementsPerSecond,
                        progress: isMeasuring ? totalProgress : 0
                    )
//                }
//
                if measurements.isEmpty {
                    VStack {
                        //                    Spacer()
                        Text("touch-to-start")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.redAccent)
                        //                    Spacer()
                    }
                }
                
            }
            .frame( maxWidth: .infinity)
            .onTapGesture {
                if remainingTime == 0 && setCount == 0 &&  mipMeasurements.isEmpty && mepMeasurements.isEmpty {
                    //TODO: -
                    if viewModel.isConnected {
//                    startMock = true
                        viewModel.sendCommand(.startMeasurement, isExercise: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(restTime))) {
                            remainingTime = totalTime
                            isMeasuring = true
                        }
                    } else {
                        bluetoothNotConnected = true
                    }
                }
            }
            
            Spacer()
            
            VStack {
                
                Text(measurements.isEmpty ? "" : LocalizedStringKey(instruction))
            }
            .font(.system(size: 48))
            .bold()
            .foregroundColor(.redAccent)
        }
        .onReceive(timer) { time in
            if remainingTime > 0 {
                remainingTime -= 0.1
            }
//            if startMock {
//                mockMeasurementData.append(
////                    .init(date: .now, value: Double.random(in: -199...199))
//                    !isMeasuring ?
//                        .init(date: .now, value: 0) :
//                    currentMeasurement == .rest ?
//                        .init(date: .now, value: 0) :
//                        currentMeasurement == .mip ?
//                        .init(date: .now, value: -40) :
//                            .init(date: .now, value: 10)
//                    
//                )
//            }
        }
//        .onChange(of: elapsedSectionTime) { time in
//            print("Elaspsed time \(time)")
//            if time >  sectionTime {
//                elapsedSectionArray = Array(repeating: 0, count: Int(restTime))
//            } else {
//                if let currentMeasurement = currentMeasurement {
//                    switch currentMeasurement {
//                    case .mip:
//                        elapsedSectionArray.append(maxMipMeasurements[safe: mipCount] ?? 0)
//                    case .mep:
//                        elapsedSectionArray.append(-(maxMepMeasurements[safe: mepCount] ?? 0))
//                    case .rest:
//                        elapsedSectionArray.append(0)
//                        
//                    }
//                }
//            }
//        }
        .onChange(of: currentMeasurement){ type in
            Task {
                if let type = type {
                    switch type {
                    case .mip:
                        print("Type MIP")
                        if setCount < numberOfSets {
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(timePerSectionMIP))) {
//                                viewModel.sendCommand(.stopMeasurement)
                                mipCount += 1
                            }
                        }
                        
                    case .mep:
                        print("Type MEP")
                        if setCount < numberOfSets {
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(timePerSectionMEP))) {
//                                viewModel.sendCommand(.stopMeasurement)
                                mepCount += 1
                            }
                        }
                    case .rest:
                        print("Type Rest")
                        if isMeasuring {
                            if elapsedSectionTime < timePerSectionMIP + restTime + timePerSectionMEP{
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(restTime))) {
//                                    viewModel.sendCommand(.startMeasurement)
                                }
                            } else {
                                if (setCount + 1) < numberOfSets {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(restTime))) {
                                        setCount = setCount + 1
//                                        viewModel.sendCommand(.startMeasurement)
                                    }
                                } else {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(restTime))) {
                                        isMeasuring = false
                                        viewModel.sendCommand(.stopMeasurement)
                                        //save to coredata
                                        let exercise = ExerciseResult(context: moc)
                                        exercise.mip = maxMip
                                        exercise.mep = maxMep
                                        exercise.accuracy = Int16(accuracy)
                                        exercise.totalTime = Int16(totalTime)
                                        exercise.exerciseType = ExerciseType.endurance.rawValue
                                        
                                        selectedUser.first?.addToExerciseResults(exercise)
                                        do {
                                            try moc.save()
                                            navStore.path.append(Screens.exerciseResultsScreen(exercise.id ?? UUID()))
                                        } catch {
                                            print("Error saving exercise result")
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: viewModel.measurementData) { data in
//        .onChange(of: mockMeasurementData) { data in
            Task {
                if data.isEmpty { return }
                if let currentMeasurement = currentMeasurement {
                    switch currentMeasurement {
                    case .mip:
                        if let value = data.last?.value  {
                            let absoluteValue = abs(value)
                            if mipMeasurements[safe: mipCount] == nil {
                                mipMeasurements.append(
                                    [
                                        MeasurementData(
                                            date: data.last?.date ?? .now,
                                        value: absoluteValue
                                        )
                                    ]
                                )
                            }  else {
                                mipMeasurements[mipCount].append(
                                    .init(
                                        date: data.last?.date ?? .now,
                                        value: absoluteValue
                                    )
                                )
                            }
                            
                            //                            && value <= maxAccurateMip
                            
                            if absoluteValue >= minAccurateMip {
                                accurateMipMeasurementsCount += 1
                            }
                            measurements.append(-value)
                        }
                        
                        
                        
                    case .mep:
                        if let value = data.last?.value {
                            let absoluteValue = abs(value)
                            if mepMeasurements[safe: mepCount] == nil {
                                mepMeasurements.append(
                                    [
                                        MeasurementData(
                                            date: data.last?.date ?? .now,
                                        value: absoluteValue
                                        )
                                    ]
                                )
                            }
                            else {
                                mepMeasurements[mepCount].append(
                                    MeasurementData(
                                        date: data.last?.date ?? .now,
                                        value: absoluteValue
                                    )
                                )
                            }
                            
                            //                            && value <= maxAccurateMep
                            if absoluteValue >= maxAccurateMep
                            {
                                accurateMepMeasurementsCount += 1
                            }
                            measurements.append(-value)

                        }
                    case .rest:
                        if let value = data.last?.value {
                            measurements.append(-value)
                        }
                        
                    }
                } else {
                    if let value = data.last?.value {
                        measurements.append(-value)
                    }
                }
            }
        }

        .onAppear {
            if !viewModel.isConnected {
                bluetoothNotConnected = true
            }
        }
        
        //        .padding(.bottom, 60)
        .navBar(title: "respiratory-muscle-movement-measurement", backgroundColor: .redAccent)
        
        .fullScreenCover(isPresented: $bluetoothNotConnected) {
            InformationPopup(
                title: "notification",
                backgroundColor: .redAccent,
                child: AnyView(
                    
                    Text("please-connect-to-bluetooth")
                        .multilineTextAlignment(.center)
                )) {
                    bluetoothNotConnected = false
                }
        }
        .onAppear{
            // get setting from core data for selected user
            if let user = selectedUser.first {
                let fetchRequest = NSFetchRequest<ExerciseSetting>(entityName: "ExerciseSetting")
                fetchRequest.predicate = NSPredicate(format: "user.id == %@ AND exerciseType == %@ ", user.id! as CVarArg,  NSNumber(value: ExerciseType.strength.rawValue))
                let setting = try? moc.fetch(fetchRequest)
                print("New value found \(String(describing: setting?.first?.mipPressureRatio))")
                pressureRatioMIP = Int(setting?.first?.mipPressureRatio ?? Int16(Ints.defaultPressureRatioMIP))
                pressureRatioMEP = Int(setting?.first?.mepPressureRatio ?? Int16(Ints.defaultPressureRatioMEP))
                timePerSectionMIP = Double(Int(setting?.first?.mipTime ?? Int16(Ints.defaultTimePerSectionMIP)))
                timePerSectionMEP = Double(Int(setting?.first?.mepTime ?? Int16(Ints.defaultTimePerSectionMEP)))
                restTime = Double(Int(setting?.first?.restTime ?? Int16(Ints.defaultRestTime)))
                numberOfSets = Int(setting?.first?.setCount ?? Int16(Ints.defaultNumberOfSets))
            }
        }
        .onDisappear{
            viewModel.sendCommand(.stopMeasurement)
            mipCount = 0
            mepCount = 0
            setCount = 0
            remainingTime = 0
            mipMeasurements = []
            mepMeasurements = []
            accurateMipMeasurementsCount = 0
            accurateMepMeasurementsCount = 0
            measurements = []
            isMeasuring = false
        }
        //
    }
}

#Preview {
    NavigationView {
        if #available(iOS 17.0, *) {
            ScrollingRespiratoryExerciseMeasurementScreen(
            )
        } else {
            // Fallback on earlier versions
        }
    }
    .environmentObject(CoreBluetoothViewModel())
}
