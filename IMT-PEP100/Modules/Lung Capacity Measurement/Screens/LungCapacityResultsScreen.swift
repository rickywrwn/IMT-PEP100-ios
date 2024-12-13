//
//  LungCapacityResultsScreen.swift
//  MEP
//
//  Created by Nathan Getachew on 2/1/24.
//

import SwiftUI

enum LungDiagnosticResult {
    case normal
    case suspectedCOPD
    case suspectedRestrictiveLungDisease
    case copd
    case copdWithRestrictiveLungDisease
    
    
    var text: String {
        switch self {
        case .normal:
            return "diagnostic_normal"
        case .suspectedCOPD:
            return "diagnostic_sus_copd"
        case .suspectedRestrictiveLungDisease:
            return "diagnostic_sus_restrictive"
        case .copd:
            return "diagnostic_copd"
        case .copdWithRestrictiveLungDisease:
            return "diagnostic_copd_with_restrictive"
        }
    }
    
    var help: String {
        switch self {
        case .normal:
            return "diagnostic_normal_help"
        case .suspectedCOPD:
            return "diagnostic_sus_copd_help"
        case .suspectedRestrictiveLungDisease:
            return "diagnostic_sus_restrictive_help"
        case .copd:
            return "diagnostic_copd_help"
        case .copdWithRestrictiveLungDisease:
            return "diagnostic_copd_with_restrictive_help"
        }
    }
    
    
}

struct LungCapacityResultsScreen: View {
    @Environment(\.managedObjectContext) private var moc
    @EnvironmentObject var navStore: NavigationStore
    @EnvironmentObject var viewModel: CoreBluetoothViewModel
    
    @State private var isHelpPresented = false 
    
    private var lungMeasurementFetchRequest : FetchRequest<LungMeasurement>
    private var lungMeasurement: FetchedResults<LungMeasurement> {
        lungMeasurementFetchRequest.wrappedValue
    }
    
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isSelected == %@", NSNumber(value: true)))
    var selectedUser: FetchedResults<User>
    
    // MARK: - Measured Values
    var fvc: Double { lungMeasurement.first?.fvc ?? 0}
    var fev1: Double { lungMeasurement.first?.fev1 ?? 0}
    var fev1_to_fvc_ratio: Double { fvc > 0 ?  fev1 / fvc : 0}
    var fef_25_to_75: Double { lungMeasurement.first?.fef_25_to_75 ?? 0}
    var pef: Double { lungMeasurement.first?.pef ?? 0}
    var mvv : Double { lungMeasurement.first?.mvv ?? 0}
    
    
    
    // MARK: - Predicted Values
    var race: Race { Race(rawValue: Int(selectedUser.first!.race)) ?? .asian}
    var gender: Gender { Gender(rawValue: Int(selectedUser.first!.gender)) ?? .male}
    var height: Double {Double(selectedUser.first!.height)}
    var weight: Double {Double(selectedUser.first!.weight)}
    var age: Double {Double(calculateAge(birthDate: selectedUser.first!.birthDate ?? .now))}
    
    var predFVC: Double { predictedFVC(race: race, gender: gender, height: height, weight: weight, age: age)}
    var predFEV1: Double { predictedFEV1(race: race, gender: gender, height: height, age: age)}
    var predFEV1_to_FVC_ratio: Double { predFVC > 0 ? predFEV1 / predFVC : 0}
    var predFEF_25_to_75: Double { predictedFEF_25_to_75(race: race, gender: gender, height: height, weight: weight, age: age)}
    var predPEF: Double { predictedPEF(race: race, gender: gender, height: height, age: age)}
    
    var diagnosis: LungDiagnosticResult {
        diagnoseResults(fvc: lungMeasurement.first?.fvc ?? 0, fev1: lungMeasurement.first?.fev1 ?? 0)
    }
    var predMVV: Double {
        if diagnosis == .normal {
            return 44.01 * fev1 - 21.09
        } else if diagnosis == .copdWithRestrictiveLungDisease || diagnosis == .suspectedRestrictiveLungDisease {
            
            return  38.34 * fev1 - 4.58
        } else if diagnosis == .copd || diagnosis == .suspectedCOPD {
            
            return 45.2 * fev1 - 3.8
        }
        return 0
    }
     
    
    private var flowRateData: [MeasurementData] {
        let flowRate: [MeasurementData] = (lungMeasurement.first?.measurements?.allObjects as? [Measurement])?.map { item in
            let flowRate = calculateFlowRate(for: item.value)
             return MeasurementData(date: item.date ?? .now, value: flowRate)
         } ?? []
        
        return flowRate.sorted(by: { $0.date < $1.date })
    }
        
    
    init(id: UUID){
        lungMeasurementFetchRequest = FetchRequest(
            sortDescriptors: [],
            predicate: NSPredicate(format: "id == %@", id as CVarArg ))
    }
    
    var body: some View {
        VStack(spacing: 0){
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        
                        LungCapacityResultsChart(results: flowRateData)
                        
                        Spacer()
                        
                        LungCapacityResultsTable(
                            fvc: fvc,
                            fev1: fev1,
                            fev1_to_fvc_ratio: fev1_to_fvc_ratio,
                            fef_25_to_75: fef_25_to_75,
                            pef: pef,
                            mvv: mvv,
                            
                            predFVC: predFVC,
                            predFEV1: predFEV1,
                            predFEV1_to_FVC_ratio: predFEV1_to_FVC_ratio,
                            predFEF_25_to_75: predFEF_25_to_75,
                            predPEF: predPEF,
                            predMVV: predMVV
                        )
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            
                            HStack {
                                Text("diagnosis-result") + Text(": ") + Text(LocalizedStringKey( diagnosis.text))
                                Button {
                                    isHelpPresented = true
                                } label: {
                                    Image(systemName: "questionmark")
                                        .padding(.horizontal,6)
                                        .padding(.vertical,6)
                                        .background(.greenAccent)
                                        .foregroundColor(.white)
                                        .cornerRadius(4)
                                        .font(.callout)
                                }
                            }
                            HStack {
                                Text("lung-age") + Text(": ") + Text("\(calculateAge(birthDate: selectedUser.first?.birthDate ?? .now)) years-old")
                                Spacer()
                            }
                            
                        }
                        .frame(maxWidth: .infinity)
                        
                        Spacer()
                    }
                    .frame(height: geometry.size.height)
                }
            }
            
            HStack(spacing: 4){
                GridRowButton(title: "breathing-exercise", backgroundColor: .greenAccent){
                    navStore.path.removeLast(navStore.path.count)
                    navStore.path.append(Screens.chooseExercise)
                }
                GridRowButton(title: "spirometry", backgroundColor: .greenAccent){
                    navStore.path.removeLast(navStore.path.count - 1)
                }
                
                GridRowButton(title: "list", backgroundColor: .greenAccent){
                    navStore.path.append(Screens.lungMeasurementResultsListScreen(selectedUser.first!.id ?? UUID()))
                }
            }
            
            .fixedSize(horizontal: false, vertical: true)
            //            .padding([.horizontal, .bottom])
            .padding(.top, 4)
        }
        .padding()
        .navBar(title: "lung-capacity-results", backgroundColor: .greenAccent)
        .toolbar {
            ToolbarItem(placement: .principal){
                VStack {
                    Text("respiratory-measurement-results")
                    Text((lungMeasurement.first?.createdAt ?? .now)
                        .formatted(date: .numeric, time: .shortened))
                        .font(.caption2)
                }
            }
            ToolbarItem {
                SelectedProfileView(selectedUser: selectedUser.first)
                
            }
        }
        
        .fullScreenCover(isPresented: $isHelpPresented) {
            InformationPopup(
                title: "results_meaning",
                backgroundColor: .greenAccent,
                child: AnyView(
                    
                    Text(LocalizedStringKey( diagnosis.help))
                        .multilineTextAlignment(.leading)
                )) {
                    isHelpPresented = false
                }
        }

        
    }
}

#Preview {
    NavigationView {
        LungCapacityResultsScreen(id: UUID())
    }
}
