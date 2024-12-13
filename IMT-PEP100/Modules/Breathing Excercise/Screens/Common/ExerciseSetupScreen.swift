//
//  ExerciseSetupScreen.swift
//  MEP
//
//  Created by Nathan Getachew on 2/9/24.
//

import SwiftUI
import CoreData

struct ExerciseSetupScreen: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.dismiss) private var dismiss
    
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isSelected == %@", NSNumber(value: true)))
    var selectedUser: FetchedResults<User>
    
    let type: ExerciseType
    init(type: ExerciseType) {
        self.type = type

    }
    let cellBg : Color = .gray.opacity(0.4)
    @State private var pressureRatioMIP: Int = Ints.defaultPressureRatioMIP
    @State private var pressureRatioMEP: Int = Ints.defaultPressureRatioMEP
    @State private var timePerSectionMIP: Int = Ints.defaultTimePerSectionMIP
    @State private var timePerSectionMEP: Int = Ints.defaultTimePerSectionMEP
    @State private var restTime: Int = Ints.defaultRestTime
    @State private var numberOfSets: Int = Ints.defaultNumberOfSets

    var totalMinutes : Int {
        let totalSeconds = numberOfSets * (timePerSectionMEP + restTime + timePerSectionMIP +  restTime)
        return Int(totalSeconds / 60)
    }
    var totalSeconds: Int {
        let totalSeconds = numberOfSets * (timePerSectionMEP + restTime + timePerSectionMIP +  restTime)
        return Int(totalSeconds % 60)
    }
    
    var body: some View {
        VStack {
            Grid(horizontalSpacing: 0, verticalSpacing: 40) {
                
                GridRow {
                    Text("")
                        .modifyCell(
                            backgroundColor: cellBg,
                            foregroundColor: .black
                        )
                    Text("MIP")
                        .modifyCell(
                            backgroundColor: cellBg,
                            foregroundColor: .black
                        )
                    Text("MEP")
                        .padding(.vertical, 8)
                        .modifyCell(
                            backgroundColor: cellBg,
                            foregroundColor: .black
                        )
                }
                GridRow {
                    VStack {
                        Text("pressure-ratio")
                            .font(.title3)
                            .bold()
                        Text("Unit : %")
                            .font(.callout)
                    }
                    ChangeValueView(
                        value: $pressureRatioMIP ,
                        min: Ints.minPressureRatioMIP,
                        max: Ints.maxPressureRatioMIP,
                        step: 5
                    )
                    ChangeValueView(
                        value: $pressureRatioMEP,
                        min: Ints.minPressureRatioMEP,
                        max: Ints.maxPressureRatioMEP,
                        step: 5
                    )
                    
                }
                GridRow {
                    VStack {
                        Text("time-per-section")
                            .font(.title3)
                            .bold()
                        Text("Unit : sec")
                            .font(.callout)
                    }
                    ChangeValueView(
                        value: $timePerSectionMIP,
                        min: Ints.minTimePerSectionMIP,
                        max: Ints.maxTimePerSectionMIP
                    )
                    ChangeValueView(
                        value: $timePerSectionMEP,
                        min: Ints.minTimePerSectionMEP,
                        max: Ints.maxTimePerSectionMEP
                    )
                    
                    
                }
                GridRow {
                    VStack {
                        Text("rest-time")
                            .font(.title3)
                            .bold()
                        Text("Unit : sec")
                            .font(.callout)
                    }
                    ChangeValueView(
                        value: $restTime ,
                        min: Ints.minRestTime,
                        max: Ints.maxRestTime
                    )
                    .gridCellColumns(2)
                }
                GridRow {
                    Text("number-of-sets")
                        .font(.title3)
                        .bold()
                    ChangeValueView(
                        value: $numberOfSets ,
                        min: Ints.minNumberOfSets,
                        max: Ints.maxNumberOfSets
                    )
                    .gridCellColumns(2)
                }
                
            }
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            Spacer()
            
            Text("exercise time \(totalMinutes) minutes \(totalSeconds) seconds ")
            
            Button {
                if let user = selectedUser.first {
                    let fetchRequest = NSFetchRequest<ExerciseSetting>(entityName: "ExerciseSetting")
                    fetchRequest.predicate = NSPredicate(format: "user.id == %@ AND exerciseType == %@ ", user.id! as CVarArg,  NSNumber(value: type.rawValue))
                    let result = try? moc.fetch(fetchRequest)
                    
                    let setting = result?.first ?? ExerciseSetting(context: moc)
                    setting.exerciseType = type.rawValue
                    setting.mipPressureRatio = Int16(pressureRatioMIP)
                    setting.mepPressureRatio = Int16(pressureRatioMEP)
                    setting.mipTime = Int16(timePerSectionMIP)
                    setting.mepTime = Int16(timePerSectionMEP)
                    setting.restTime = Int16(restTime)
                    setting.setCount = Int16(numberOfSets)
                    
                    user.addToExerciseSettings(setting)
                    
                    do {
                        try moc.save()
                        dismiss()
                    } catch {
                        print("Error saving settings")
                    }
                }
                
                
            } label: {
                Text("apply")
                    .padding()
                    .background(.redAccent)
                    .foregroundColor(.white)
            }
            .padding()
            
        }
        //        .padding()
        .navBar(title: "respiratory-exercise-setup", backgroundColor: .redAccent)
        .onAppear {
            if let user = selectedUser.first {
                
                let fetchRequest = NSFetchRequest<ExerciseSetting>(entityName: "ExerciseSetting")
                fetchRequest.predicate = NSPredicate(format: "user.id == %@ AND exerciseType == %@ ", user.id! as CVarArg,  NSNumber(value: type.rawValue))
                let setting = try? moc.fetch(fetchRequest)
                
                pressureRatioMIP = Int(setting?.first?.mipPressureRatio ?? Int16(Ints.defaultPressureRatioMIP))
                pressureRatioMEP = Int(setting?.first?.mepPressureRatio ?? Int16(Ints.defaultPressureRatioMEP))
                timePerSectionMIP = Int(setting?.first?.mipTime ?? Int16(Ints.defaultTimePerSectionMIP))
                timePerSectionMEP = Int(setting?.first?.mepTime ?? Int16(Ints.defaultTimePerSectionMEP))
                restTime = Int(setting?.first?.restTime ?? Int16(Ints.defaultRestTime))
                numberOfSets = Int(setting?.first?.setCount ?? Int16(Ints.defaultNumberOfSets))
            }
        }
    }
}
