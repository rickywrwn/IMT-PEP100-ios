//
//  EnduranceExerciseScreen.swift
//  MEP
//
//  Created by Nathan Getachew on 2/6/24.
//

import SwiftUI
import CoreData

struct EnduranceExerciseMeasurementScreen: View {
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
    @State  var mipCount = 0
    @State var accurateMipMeasurementsCount: Int = 0
    @State var mipMeasurements: [[MeasurementData]] = []
    var maxMipMeasurements: [Double] {
        mipMeasurements.map { $0.map { $0.value }.max() ?? 0 }
    }
    var maxMip: Double {
        maxMipMeasurements.max() ?? 0
    }
    
    
    @State  var mepCount = 0
    @State  var mepMeasurements: [[MeasurementData]] = []
    @State  var accurateMepMeasurementsCount: Int = 0
    var maxMepMeasurements: [Double] {
        mepMeasurements.map { $0.map { $0.value }.max() ?? 0 }
    }
    var maxMep: Double {
        maxMepMeasurements.max() ?? 0
    }
    
    @State var accurateRestMeasurementsCount: Int = 0
    
    
    @State  var setCount = 0
    @State  var remainingTime: Double = 0
    
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
    
    
    @State var width: CGFloat = 0
    
    @State var measurements: [Double] = []
    
    var lastMeasurement: Double {
        measurements.last ?? 0
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
            
            GeometryReader { geometry in
                
                ZStack(alignment: .topLeading) {
                    
                    Button {
                        if remainingTime == 0 && setCount == 0 &&  mipMeasurements.isEmpty && mepMeasurements.isEmpty {
                            //TODO: -
                            if viewModel.isConnected {
                                remainingTime = totalTime
                                viewModel.sendCommand(.startMeasurement,isExercise: true)
                                isMeasuring = true
                            } else {
                                bluetoothNotConnected = true
                            }
                        }
                        
                    } label: {
                        
                        
                        
                        ZStack {
                            Circle()
                                .foregroundColor(.redAccent)
                                .scaleEffect(scale)
                            
                            Circle()
                                .stroke(Color.black, lineWidth: 4)
                                .scaleEffect(scalePressure)
                            
                            
                            
                            Text(isMeasuring ? LocalizedStringKey(instruction) : "START")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .scaleEffect(scale)
                        }
                        
                        
                        
                    }
                    .padding(48)
                    .disabled(!(remainingTime == 0 && setCount == 0 &&  mipMeasurements.isEmpty && mepMeasurements.isEmpty))
                    
                    .border(.redAccent, width: 12)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    
                    
                    
                    
                    if isMeasuring {
                        Circle()
                            .foregroundColor(Color.redAccent)
                            .frame(width: 32, height: 32)
                            .offset(
                                x: offSetX,
                                y: offSetY
                            )
                    }
                    
                }
                .fixedSize(horizontal: false, vertical: false)
                .onAppear{
                    width = geometry.size.width
                }
            }
            
            
            
            Spacer()
            
        }
        .padding()
        .onReceive(timer) { time in
            if remainingTime > 0 {
                remainingTime -= 0.1
            }
        }
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
            Task {
                if !isMeasuring || data.isEmpty { return }
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
                            if value >= -10 && value <= 10 {
                                accurateRestMeasurementsCount += 1
                            }
                            measurements.append(-value)
                        }
                        
                    }
                }
            }
        }
        //        .onChange(of: elapsedSectionArray) { array in
        //            print(array)
        //        }
        .onAppear {
            if !viewModel.isConnected {
                bluetoothNotConnected = true
            }
        }
        
        //        .padding(.bottom, 60)
        .navBar(title: "endurance-exercise", backgroundColor: .redAccent)
        
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
            Task {
                // get setting from core data for selected user
                if let user = selectedUser.first {
                    let fetchRequest = NSFetchRequest<ExerciseSetting>(entityName: "ExerciseSetting")
                    fetchRequest.predicate = NSPredicate(format: "user.id == %@ AND exerciseType == %@ ", user.id! as CVarArg,  NSNumber(value: ExerciseType.endurance.rawValue))
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
            accurateRestMeasurementsCount = 0
            isMeasuring = false
            
        }
        //
    }
    
}

#Preview {
    NavigationView {
    }
}
