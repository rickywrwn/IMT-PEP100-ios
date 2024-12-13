//
//  ChooseExerciseScreen.swift
//  MEP
//
//  Created by Nathan Getachew on 2/6/24.
//

import SwiftUI
import CoreData

enum ExerciseType: Int16, CaseIterable, Codable {
    case endurance = 1
    case strength = 2
    
    var id: Int16 { self.rawValue }
    
    var title: String {
        switch self {
        case .endurance:
            "endurance-exercise"
        case .strength:
            "strength-training"
        }
    }
}

struct ChooseExerciseScreen: View {
   @Environment(\.managedObjectContext) private var moc 
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isSelected == %@", NSNumber(value: true)))
    var selectedUser: FetchedResults<User>
    
    @EnvironmentObject var navStore: NavigationStore
   
    @State private var isHelpPresented = false
    
    var age: Int {
        calculateAge(birthDate: selectedUser.first?.birthDate ?? .now)
    }
    
    var mipPred: Int {
        if selectedUser.first!.gender == Gender.male.rawValue {
            return Int(120 - Int(0.41 * Double(age)))
        } else {
            return Int(108 - Int(0.61 * Double(age)))
        }
    }
    var mepPred: Int {
        if selectedUser.first!.gender == Gender.male.rawValue {
            return Int(174 - Int(0.83 * Double(age)))
        } else {
            return Int(131 - Int(0.86 * Double(age)))
        }
    }
    
//    let mipPred = 50
//    let mepPred = 50
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                HStack(alignment: .firstTextBaseline) {
                    Text("MIP/MEP")
                    Text("\(mipPred)/\(mepPred)")
                        .font(.system(size: 48))
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding(24)
                .background(.redAccent.opacity(0.5))
                
                Button {
                    isHelpPresented = true
                } label: {
                    Image(systemName: "questionmark")
                        .padding(.horizontal,6)
                        .padding(.vertical,6)
                        .background(.redAccent)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                        .font(.callout)
                        .padding(6)
                }

            }
            
            Spacer()
             
            HStack(spacing: 16) {
                VStack {
                    BreathingExerciseButton(label: "strength-training-shortcuts"){
                        navStore.path.append(Screens.strengthExerciseScreen)
                    }
                    BreathingExerciseSettingsButton(label: "strength-training-settings"){
                        navStore.path.append(Screens.exerciseSettingsScreen(.strength))
                    }
                    
                }
                
                VStack {
                    BreathingExerciseButton(label: "endurance-training-shortcuts"){
                        navStore.path.append(Screens.enduranceExerciseScreen)
                    }
                    BreathingExerciseSettingsButton(label: "endurance-training-settings"){
                        navStore.path.append(Screens.exerciseSettingsScreen(.endurance))
                    }
                    
                }
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button {
                    navStore.path.append(Screens.exerciseResultsListScreen(selectedUser.first!.id ?? UUID()))
                    
                } label: {
                    Text("list")
                        .padding()
                        .foregroundColor(.white)
                        .background(.redAccent)
                }
            }
            
        }
        .padding()
        .navBar(title: "breathing-exercise", backgroundColor: .redAccent)
        .toolbar {
            ToolbarItem {
                SelectedProfileView(selectedUser: selectedUser.first)
                
            }
        }
        .fullScreenCover(isPresented: $isHelpPresented) {
            InformationPopup(
                title: "results_meaning",
                backgroundColor: .redAccent,
                child: AnyView(
                    Text("exercise-selection-help")
                        .multilineTextAlignment(.leading)
                )) {
                    isHelpPresented = false
                }
        }
        .onAppear{
            // get settings from core data for selected user
            Task {
            if let selectedUser = selectedUser.first {
            let fetchRequest = NSFetchRequest<ExerciseSetting>(entityName: "ExerciseSetting")
            fetchRequest.predicate = NSPredicate(format: "user.id == %@", selectedUser.id! as CVarArg)
            fetchRequest.fetchLimit = 2
            let settings = try? moc.fetch(fetchRequest)
                if settings?.isEmpty ?? true {
                    let endurance = ExerciseSetting(context: moc)
                    endurance.exerciseType = ExerciseType.endurance.rawValue
                    endurance.mipPressureRatio = Int16(Ints.defaultPressureRatioMIP)
                    endurance.mepPressureRatio =  Int16(Ints.defaultPressureRatioMEP)
                    endurance.mipTime =  Int16(Ints.defaultTimePerSectionMIP)
                    endurance.mepTime =  Int16(Ints.defaultTimePerSectionMEP)
                    endurance.restTime =  Int16(Ints.defaultRestTime)
                    endurance.setCount =  Int16(Ints.defaultNumberOfSets)
                    
                    let strength = ExerciseSetting(context: moc)
                    strength.exerciseType = ExerciseType.strength.rawValue
                    strength.mipPressureRatio = Int16(Ints.defaultPressureRatioMIP)
                    strength.mepPressureRatio =  Int16(Ints.defaultPressureRatioMEP)
                    strength.mipTime =  Int16(Ints.defaultTimePerSectionMIP)
                    strength.mepTime =  Int16(Ints.defaultTimePerSectionMEP)
                    strength.restTime =  Int16(Ints.defaultRestTime)
                    strength.setCount =  Int16(Ints.defaultNumberOfSets)
                    
                    selectedUser.addToExerciseSettings(endurance)
                    selectedUser.addToExerciseSettings(strength)
                    
                    do {
                        try moc.save()
                    } catch {
                        print("Error saving settings")
                        
                    }
                }
            }
        }
        }
    }
}

#Preview {
    NavigationView {
        ChooseExerciseScreen()
            .environment(\.locale, .init(identifier: "ko"))
    }
}
