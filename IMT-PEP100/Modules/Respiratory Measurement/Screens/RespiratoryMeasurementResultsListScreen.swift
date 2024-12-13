//
//  RespiratoryMeasurementResultsListScreen.swift
//  MEP
//
//  Created by Nathan Getachew on 2/1/24.
//

import SwiftUI

struct RespiratoryMeasurementList: Identifiable{
    var id = UUID()
    var name: String
    var date: Date
    var mip: Int
    var mep: Int
    var isSelected: Bool = false
}

struct RespiratoryMeasurementResultsListScreen: View {
    @Environment(\.managedObjectContext) private var moc
    @EnvironmentObject var navStore: NavigationStore
    let grayCellBg : Color = .gray.opacity(0.3)
    
    private var respiratoryMeasurementsFetchRequest : FetchRequest<RespiratoryMeasurement>
    private var respiratoryMeasurements: FetchedResults<RespiratoryMeasurement> {
        respiratoryMeasurementsFetchRequest.wrappedValue
    }
    
    @State private var selectedIndices: [Int] = []
    @State private var isDeletionConfirmationPopupVisible = false
    
    init(for userId: UUID){
        respiratoryMeasurementsFetchRequest = FetchRequest(
            sortDescriptors: [],
            predicate: NSPredicate(format: "ANY user.id == %@",userId as CVarArg ))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            Grid(horizontalSpacing: 0){
                GridRow {
                    Text("number")
                        .modifyCell(backgroundColor: grayCellBg, foregroundColor: .accent)
                    Text("date")
                        .modifyCell(backgroundColor: grayCellBg, foregroundColor: .accent)
                    Text("name")
                        .modifyCell(backgroundColor: grayCellBg, foregroundColor: .accent)
                    Text("MIP\nMEP")
                        .modifyCell(backgroundColor: grayCellBg, foregroundColor: .accent)
                    Text("select")
                        .modifyCell(backgroundColor: grayCellBg, foregroundColor: .accent)
                }
                .multilineTextAlignment(.center)
                .frame(maxHeight: 60)
            }
            
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 0),
                    GridItem(.flexible(), spacing: 0),
                    GridItem(.flexible(), spacing: 0),
                    GridItem(.flexible(), spacing: 0),
                    GridItem(.flexible(), spacing: 0),
                ]){
                    
                    ForEach(respiratoryMeasurements.indices, id: \.self) { index in
                        let result = respiratoryMeasurements[index]
                        let isSelected = selectedIndices.contains(index)
                        GridRow {
                            Text("\(index + 1)")
                            
                            Text((result.createdAt ?? .now)
                                .formatted(date: .numeric, time: .shortened))
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            
                            Text(result.user?.name ?? "")
                                .lineLimit(1)
                            
                            Group {
                                Text(result.maxMIP != nil ? "\(Int(result.maxMIP))" : "") +
                                Text("\n") +
                                Text(result.maxMEP != nil ? "\(Int(result.maxMEP))" : "")
                            }
                            
                            Group {
                                if isSelected {
                                    Image(systemName: "checkmark.square.fill")
                                } else {
                                    Image(systemName: "square")
                                }
                            }
                            .onTapGesture {
                                if isSelected {
                                    selectedIndices.removeAll(where: { $0 == index })
                                } else {
                                    selectedIndices.append(index)
                                }
                            }
                            .font(.title3)
                        }
                    }
                }
            }
            
            Spacer()
            
            HStack(spacing: 4){
                GridRowButton(title: "delete"){
                    isDeletionConfirmationPopupVisible = true
                }
                .disabled(selectedIndices.isEmpty)
                
                GridRowButton(title:"respiratory-measurement"){
                    navStore.path.removeLast(navStore.path.count - 1)
                }
                
                GridRowButton(title: "check"){
                    if let measurement = respiratoryMeasurements[safe: selectedIndices.first ?? 0] {
                        navStore.path.append(Screens.respiratoryMeasurementResultsScreen(measurement.id ?? UUID()))
                    }
                }
                .disabled(selectedIndices.count != 1)
                
                
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding([.horizontal, .bottom])
            .padding(.top, 4)
            
            
        }
        //                .padding()
        .navBar(title: "respiratory-measurement-results-list")
        .fullScreenCover(isPresented: $isDeletionConfirmationPopupVisible) {
            UserDeletionConfirmationPopup(label: "sure-to-delete") {
                for index in selectedIndices {
                    do {
                        let result = respiratoryMeasurements[index]
                        moc.delete(result)
                        try moc.save()
                        selectedIndices.removeAll(where: {$0 == index})
                    } catch let error {
                        print("Error deleting results: \(error)")
                    }
                }
                isDeletionConfirmationPopupVisible = false
            } onCancel: {
                isDeletionConfirmationPopupVisible = false
            }
        }
    }
    
    
}

#Preview {
    NavigationView {
        RespiratoryMeasurementResultsListScreen(for: UUID())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
