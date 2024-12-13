//
//  RespiratoryExerciseMeasurementScreen.swift
//  MEP
//
//  Created by Nathan Getachew on 2/11/24.
//

import SwiftUI
import CoreData

enum ExerciseMeasurementType {
    case mip
    case mep
    case rest
    
    var title: String {
        switch self {
        case .mip:
            "MIP"
        case .mep:
            "MEP"
        case .rest:
            "Rest"
        }
    }
}

struct RespiratoryExerciseMeasurementScreen: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var viewModel: CoreBluetoothViewModel
    @EnvironmentObject var navStore: NavigationStore
    
    @State private var pressureRatioMIP: Int = Ints.defaultPressureRatioMIP
    
    @State private var pressureRatioMEP: Int = Ints.defaultPressureRatioMEP
    @State private var timePerSectionMIP: Int = Ints.defaultTimePerSectionMIP
    @State private var timePerSectionMEP: Int = Ints.defaultTimePerSectionMEP
    @State private var restTime: Int = Ints.defaultRestTime
    @State private var numberOfSets: Int = Ints.defaultNumberOfSets
    
    
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isSelected == %@", NSNumber(value: true)))
    var selectedUser: FetchedResults<User>
    var age: Int {
        calculateAge(birthDate: selectedUser.first?.birthDate ?? .now)
    }
    var predMIP: Int {
        if selectedUser.first!.gender == Gender.male.rawValue {
            return Int(120 - Int(0.41 * Double(age)))
        } else {
            return Int(108 - Int(0.61 * Double(age)))
        }
    }
    
    var adjustedMIP: Int {
        Int(predMIP * pressureRatioMIP / 100)
    }
    
    
    var predMEP: Int {
        if selectedUser.first!.gender == Gender.male.rawValue {
            return Int(174 - Int(0.83 * Double(age)))
        } else {
            return Int(131 - Int(0.86 * Double(age)))
        }
    }
    
    var adjustedMEP: Int {
        Int(predMEP * pressureRatioMEP / 100)
    }
    //    let predMIP = 50
    //    let predMEP = 50
    
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
    //MARK: - MIP
    var minAccurateMip: Double {
        Double(adjustedMIP) * 0.8
    }
    var maxAccurateMip: Double {
        Double(adjustedMIP) * 1.2
    }
    var totalMipMeasurementsCount: Int {
        measurementsPerSecond * Int(timePerSectionMIP) * numberOfSets
    }
    //    var mipAccuracy = 0
    var mipAccuracy: Int {

        let acc: Double = Double(accurateMipMeasurementsCount)  / Double(totalMipMeasurementsCount) * 100
        return  min(Int(acc),100)
    }
    
    @State private var mepCount = 0
    @State var accurateMepMeasurementsCount: Int = 0
    @State private var mepMeasurements: [[MeasurementData]] = []
    var maxMepMeasurements: [Double] {
        mepMeasurements.map { $0.map { $0.value }.max() ?? 0 }
    }
    var maxMep: Double {
        maxMepMeasurements.max() ?? 0
    }
    var minAccurateMep: Double {
        Double(adjustedMEP) * 1.2
    }
    
    var maxAccurateMep: Double {
        Double(adjustedMEP) * 0.8
    }
    
    var totalMepMeasurementsCount: Int {
        measurementsPerSecond * Int(timePerSectionMEP) * numberOfSets
    }
    //    var mepAccuracy = 0
    var mepAccuracy: Int {
        let acc: Double = Double(accurateMepMeasurementsCount)  / Double(totalMepMeasurementsCount) * 100
        return min(Int(acc),100)
    }
        
    var accuracy: Int {

        let acc: Double = (Double(mipAccuracy) + Double(mepAccuracy) ) / 2
        return min(Int(acc),100)
    }
    
    @State private var setCount = 0
    @State private var remainingTime = 0
    let measurementsPerSecond = 10

    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var sectionTime: Int {
        timePerSectionMEP + restTime + timePerSectionMIP +  restTime
    }
    var totalTime : Int {
        numberOfSets * sectionTime
    }
    
    var elapsedTime: Int {
        totalTime - remainingTime
    }
    
    var elapsedSectionTime: Int {
        return elapsedTime - ( setCount *  sectionTime)
    }
    
    var totalProgress: Double {
        Double( elapsedTime) / Double(totalTime)
    }
    
    @State private var elapsedSectionArray: [Double] = []
    
    var currentMeasurement: ExerciseMeasurementType? {
        if elapsedSectionTime <= timePerSectionMIP {
            return .mip
        } else if elapsedSectionTime <= timePerSectionMIP + restTime {
            return .rest
        } else if elapsedSectionTime <= timePerSectionMIP + restTime + timePerSectionMEP {
            return .mep
        } else if elapsedSectionTime <= timePerSectionMIP + restTime + timePerSectionMEP + restTime {
            return .rest
        } else {
            return nil
        }
    }
    
    var currentMeasurementElapsedTime: Int {
        if elapsedSectionTime <= timePerSectionMIP {
            return elapsedSectionTime
        } else if elapsedSectionTime <= timePerSectionMIP + restTime {
            return elapsedSectionTime - timePerSectionMIP
        } else if elapsedSectionTime <= timePerSectionMIP + restTime + timePerSectionMEP {
            return elapsedSectionTime - (timePerSectionMIP + restTime)
        } else if elapsedSectionTime <= timePerSectionMIP + restTime + timePerSectionMEP + restTime {
            return elapsedSectionTime - (timePerSectionMIP + restTime + timePerSectionMEP)
        } else {
            return 0
        }
    }
    
    
    var currentMeasurementTotalTime: Int {
        switch currentMeasurement {
        case .mip:
            return timePerSectionMIP
        case .mep:
            return timePerSectionMEP
        case .rest:
            return restTime
        case nil:
            return 0
        }
    }
    
    var  currentMeasurementProgress: Double {
        Double( currentMeasurementElapsedTime) / Double(currentMeasurementTotalTime)
    }
    
    
    var instruction: String {
        switch currentMeasurement {
        case .mip:
            "breath-in"
        case .mep:
            "breath-out"
        default:
            " "
        }
    }
    
    var measurements: [MeasurementData] {
        viewModel.measurementData
    }
    
    
    
    
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
                    let minutes = elapsedTime / 60
                    let seconds = elapsedTime % 60
                    
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
                
                PredictedRespiratoryChart(
                    mipTime: timePerSectionMIP,
                    mepTime: timePerSectionMEP,
                    restTime: restTime,
                    predMIP: adjustedMIP,
                    predMEP: adjustedMEP,
                    maxMIP: max(adjustedMIP, Int(maxMip)),
                    maxMEP: max(adjustedMEP, Int(maxMep))
                        
                )
                
                RespiratoryMuscleMovementChart(
                    measurements: elapsedSectionArray,
                    predMIP: adjustedMIP,
                    predMEP: adjustedMEP
                )
                
                if setCount == 0 && !isMeasuring {
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
            .frame(maxWidth: .infinity)
            .onTapGesture {
                if mipMeasurements.isEmpty && mepMeasurements.isEmpty {
                    //TODO: -
                    if viewModel.isConnected {
                        remainingTime = totalTime
                        viewModel.sendCommand(.startMeasurement)
                        isMeasuring = true
                        
                    } else {
                        bluetoothNotConnected = true
                    }
                }
            }
            
            Spacer()
            
            VStack {
                Text(LocalizedStringKey(instruction))
            }
            .font(.system(size: 48))
            .bold()
            .foregroundColor(.redAccent)
        }
        .onReceive(timer) { time in
            if remainingTime > 0 {
                remainingTime -= 1
            }
        }
        .onChange(of: elapsedSectionTime) { time in
            print("Elaspsed time \(time)")
            if time >  sectionTime {
                elapsedSectionArray = Array(repeating: 0, count: restTime)
            } else {
                if let currentMeasurement = currentMeasurement {
                    switch currentMeasurement {
                    case .mip:
                        elapsedSectionArray.append(maxMipMeasurements[safe: mipCount] ?? 0)
                    case .mep:
                        elapsedSectionArray.append(-(maxMepMeasurements[safe: mepCount] ?? 0))
                    case .rest:
                        elapsedSectionArray.append(0)
                        
                    }
                }
            }
        }
        .onChange(of: currentMeasurement){ type in
            if let type = type {
                switch type {
                case .mip:
                    print("Type MIP")
                    if setCount < numberOfSets {
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(timePerSectionMIP)) {
                            viewModel.sendCommand(.stopMeasurement)
                            mipCount += 1
                        }
                    }
                    
                case .mep:
                    print("Type MEP")
                    if setCount < numberOfSets {
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(timePerSectionMEP)) {
                            viewModel.sendCommand(.stopMeasurement)
                            mepCount += 1
                        }
                    }
                case .rest:
                    print("Type Rest")
                    if isMeasuring {
                        if elapsedSectionTime < timePerSectionMIP + restTime + timePerSectionMEP {
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(restTime)) {
                                viewModel.sendCommand(.startMeasurement)
                            }
                        } else {
                            if (setCount + 1) < numberOfSets {
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(restTime)) {
                                    setCount = setCount + 1
                                    viewModel.sendCommand(.startMeasurement)
                                }
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(restTime)) {
                                    isMeasuring = false
                                    //save to coredata
                                    let exercise = ExerciseResult(context: moc)
                                    exercise.mip = maxMip
                                    exercise.mep = maxMep
                                    exercise.accuracy = Int16(accuracy)
                                    exercise.totalTime = Int16(totalTime)
                                    exercise.exerciseType = ExerciseType.strength.rawValue
                                    
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
        .onChange(of: viewModel.measurementData) { data in
            if !isMeasuring || data.isEmpty { return }
            if let currentMeasurement = currentMeasurement {
                switch currentMeasurement {
                case .mip:
                    if mipMeasurements[safe: mipCount] == nil {
                        mipMeasurements.append(data)
                    } else {
                        mipMeasurements[mipCount] = data
                    }
                    if let value = data.last?.value {
                        
                        if value >= minAccurateMip
                        //                            && value <= maxAccurateMip
                        {
                            accurateMipMeasurementsCount += 1
                        }
                    }
                case .mep:
                    if mepMeasurements[safe: mepCount] == nil {
                        mepMeasurements.append(data)
                    } else {
                        mepMeasurements[mepCount] = data
                    }
                    if let value = data.last?.value {
                        if value >= maxAccurateMep
                        //                            && value <= maxAccurateMep
                        {
                            accurateMepMeasurementsCount += 1
                        }
                    }
                default:
                    break
                    
                }
            }
        }
        .onChange(of: elapsedSectionArray) { array in
            print(array)
        }
        .onAppear {
            if !viewModel.isConnected {
                bluetoothNotConnected = true
            }
            if elapsedSectionArray.isEmpty {
                elapsedSectionArray = Array(repeating: 0, count: restTime - 1)
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
                timePerSectionMIP = Int(setting?.first?.mipTime ?? Int16(Ints.defaultTimePerSectionMIP))
                timePerSectionMEP = Int(setting?.first?.mepTime ?? Int16(Ints.defaultTimePerSectionMEP))
                restTime = Int(setting?.first?.restTime ?? Int16(Ints.defaultRestTime))
                numberOfSets = Int(setting?.first?.setCount ?? Int16(Ints.defaultNumberOfSets))
            }
        }
        .onDisappear{
            viewModel.sendCommand(.stopMeasurement)
            mipCount = 0
            mepCount = 0
            setCount = 0
            remainingTime = 0
            elapsedSectionArray = []
            mipMeasurements = []
            mepMeasurements = []
            accurateMipMeasurementsCount = 0
            accurateMepMeasurementsCount = 0
            isMeasuring = false
        }
        //
    }
}

#Preview {
    NavigationView {
        RespiratoryExerciseMeasurementScreen(
        )
    }
    .environmentObject(CoreBluetoothViewModel())
}
