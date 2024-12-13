//
//  RespiratoryMeasurementResultsScreen.swift
//  MEP
//
//  Created by Nathan Getachew on 2/1/24.
//

import SwiftUI

struct RespiratoryMeasurementResultsScreen: View {
    @Environment(\.managedObjectContext) private var moc
    @EnvironmentObject var navStore: NavigationStore
    @EnvironmentObject var viewModel: CoreBluetoothViewModel
    
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isSelected == %@", NSNumber(value: true)))
    var selectedUser: FetchedResults<User>
    
    private var respiratoryMeasurementFetchRequest : FetchRequest<RespiratoryMeasurement>
    private var respiratoryMeasurement: FetchedResults<RespiratoryMeasurement> {
        respiratoryMeasurementFetchRequest.wrappedValue
    }
    
    init(id: UUID){
        respiratoryMeasurementFetchRequest = FetchRequest(
            sortDescriptors: [],
            predicate: NSPredicate(format: "id == %@", id as CVarArg ))
    }
    
    var mipMeasurements: [[MeasurementData]] {
        // convert to array of MIPMeasurement
        let firstThreeMipMeasurements = (respiratoryMeasurement.first?.mipMeasurements?.allObjects as? [MIPMeasurement])?.prefix(3)
        guard let firstThreeMipMeasurements = firstThreeMipMeasurements else { return [] }
        var mipMeasurementsArray: [[MeasurementData]] = []
        firstThreeMipMeasurements.forEach { mipMeasurement in
            var measurements: [MeasurementData] = []
            (mipMeasurement.measurements?.allObjects as? [Measurement])?
                .sorted(by: {$0.date ?? .now < $1.date ?? .now})
                .forEach{ item in
                    let measurement = MeasurementData(date: item.date ?? .now, value: item.value)
                    measurements.append(measurement)
                }
            mipMeasurementsArray.append(measurements)
        }
        return mipMeasurementsArray
    }
    
    var mepMeasurements: [[MeasurementData]] {
        // convert to array of MEPMeasurement
        let firstThreeMepMeasurements = (respiratoryMeasurement.first?.mepMeasurements?.allObjects as? [MEPMeasurement])?.prefix(3)
        guard let firstThreeMepMeasurements = firstThreeMepMeasurements else { return [] }
        var mepMeasurementsArray: [[MeasurementData]] = []
        firstThreeMepMeasurements.forEach { mepMeasurement in
            var measurements: [MeasurementData] = []
            (mepMeasurement.measurements?.allObjects as? [Measurement])?
                .sorted(by: {$0.date ?? .now < $1.date ?? .now})
                .forEach{ item in
                    let measurement = MeasurementData(date: item.date ?? .now, value: item.value)
                    measurements.append(measurement)
                }
            mepMeasurementsArray.append(measurements)
        }
        return mepMeasurementsArray
    }
    
    var maxMIPMeasurements: [Double] {
        mipMeasurements.map { $0.compactMap { $0.value }.max() ?? 0  }
    }
    var maxMEPMeasurements: [Double] {
        mepMeasurements.map { $0.compactMap { $0.value }.max() ?? 0  }
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
                        
                        Grid {
                            
                            GridRow {
                                Text("1st")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.accent)
                                
                                Text(maxMIPMeasurements[safe: 0] != nil ? "\(maxMIPMeasurements[safe: 0] ?? 0, specifier: "%.2f")" : "")
                                
                                Text(maxMEPMeasurements[safe: 0] != nil ? "\(maxMEPMeasurements[safe: 0] ?? 0, specifier: "%.2f")" : "")
                            }
                            
                            GridRow {
                                Text("2nd")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.accent)
                                
                                Text(maxMIPMeasurements[safe: 1] != nil ? "\(maxMIPMeasurements[safe: 1] ?? 0, specifier: "%.2f")" : "")
                                
                                Text(maxMEPMeasurements[safe: 1] != nil ? "\(maxMEPMeasurements[safe: 1] ?? 0, specifier: "%.2f")" : "")
                            }
                            GridRow {
                                Text("3rd")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.accent)
                                
                                Text(maxMIPMeasurements[safe: 2] != nil ? "\(maxMIPMeasurements[safe: 2] ?? 0, specifier: "%.2f")" : "")
                                
                                Text(maxMEPMeasurements[safe: 2] != nil ? "\(maxMEPMeasurements[safe: 2] ?? 0, specifier: "%.2f")" : "")
                            }
                            
                            GridRow{
                                Spacer()
                                Spacer()
                                Spacer()
                            }
                            .frame(height: 2)
                        }
                        .padding(.vertical)
                        
                        Spacer()
                        
                        if let measurement = respiratoryMeasurement.first {
                            RespiratoryResultsTable(measurement: measurement)
                        }
                        
                        Spacer()
                    }
                    .frame(height: geometry.size.height)
                }
            }
            //            .padding()
            
            HStack(spacing: 4) {
                GridRowButton(title: "breathing-exercise"){
                    navStore.path.removeLast(navStore.path.count)
                    navStore.path.append(Screens.chooseExercise)
                }
                
                GridRowButton(title: "respiratory-measurement"){
                    navStore.path.removeLast(navStore.path.count - 1)
                }
                
                GridRowButton(title: "list"){
                    navStore.path.append(Screens.respiratoryMeasurementResultsListScreen(selectedUser.first!.id ?? UUID()))
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            //            .padding([.horizontal, .bottom])
            .padding(.top, 4)
            
        }
        .padding()
        .navBar(title: "respiratory-measurement-results")
        .toolbar {
            ToolbarItem(placement: .principal){
                VStack {
                    Text("respiratory-measurement-results")
                    Text((respiratoryMeasurement.first?.createdAt ?? .now)
                        .formatted(date: .numeric, time: .shortened))
                        .font(.caption2)
                }
            }
            ToolbarItem {
                SelectedProfileView(selectedUser: selectedUser.first)
                
            }
        }
    }
    
    var row1 : some View {
        GridRow {
            Text("YES")
            RadioButton(isSelected: .constant(true))
            RadioButton(isSelected: .constant(false))
        }
    }
}

#Preview {
    NavigationView {
        RespiratoryMeasurementResultsScreen(id: UUID())
            .environment(\.locale, Locale(identifier: "en"))
        
    }
}
