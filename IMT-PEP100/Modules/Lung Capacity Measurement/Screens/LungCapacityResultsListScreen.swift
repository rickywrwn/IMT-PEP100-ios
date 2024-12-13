//
//  LungCapacityResultsListScreen.swift
//  MEP
//
//  Created by Nathan Getachew on 2/4/24.
//

import SwiftUI

struct LungCapacityResultsListScreen: View {
    @Environment(\.managedObjectContext) private var moc
    @EnvironmentObject var navStore: NavigationStore
    let grayCellBg : Color = .gray.opacity(0.3)
    
    private var lungMeasurementsFetchRequest : FetchRequest<LungMeasurement>
    private var lungMeasurements: FetchedResults<LungMeasurement> {
        lungMeasurementsFetchRequest.wrappedValue
    }
    
    @State private var selectedIndices: [Int] = []
    @State private var isDeletionConfirmationPopupVisible = false
    
    init(for userId: UUID){
        lungMeasurementsFetchRequest = FetchRequest(
            sortDescriptors: [],
            predicate: NSPredicate(format: "ANY user.id == %@",userId as CVarArg ))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Grid(horizontalSpacing: 0){
                GridRow {
                    Text("number")
                        .modifyCell(backgroundColor: grayCellBg, foregroundColor: .greenAccent)
                    Text("name")
                        .modifyCell(backgroundColor: grayCellBg, foregroundColor: .greenAccent)
                    Text("date")
                        .modifyCell(backgroundColor: grayCellBg, foregroundColor: .greenAccent)
                    Text("FVC\nFEV1")
                        .modifyCell(backgroundColor: grayCellBg, foregroundColor: .greenAccent)
                    Text("select")
                        .modifyCell(backgroundColor: grayCellBg, foregroundColor: .greenAccent)
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
                    
                    ForEach(lungMeasurements.indices, id: \.self) { index in
                        let result = lungMeasurements[index]
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
                                Text(result.fvc != nil ? "\(result.fvc, specifier: "%.2f")" : "") +
                                Text("\n") +
                                Text(result.fev1 != nil ? "\(result.fev1, specifier: "%.2f")" : "")
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
                .foregroundColor(.greenAccent)
            }
            
            Spacer()
            
            HStack(spacing: 4){
                GridRowButton(
                    title: "delete",
                    backgroundColor: .greenAccent,
                    disabled: selectedIndices.isEmpty
                ){
                    isDeletionConfirmationPopupVisible = true
                }
                GridRowButton(
                    title:"spirometry",
                    backgroundColor: .greenAccent
                ){
                    navStore.path.removeLast(navStore.path.count - 1)
                }
                
                GridRowButton(
                    title: "check",
                    backgroundColor: .greenAccent,
                    disabled: selectedIndices.count != 1
                ){
                    if let measurement = lungMeasurements[safe: selectedIndices.first ?? 0] {
                        navStore.path.append(Screens.lungMeasurementResultsScreen(measurement.id ?? UUID()))
                    }
                }
//                .disabled(selectedIndices.count != 1)

            }
            .fixedSize(horizontal: false, vertical: true)
            .padding([.horizontal, .bottom])
            .padding(.top, 4)


        }
        .navBar(title: "lung-capacity-results-list", backgroundColor: .greenAccent)
        .fullScreenCover(isPresented: $isDeletionConfirmationPopupVisible) {
            UserDeletionConfirmationPopup(label: "sure-to-delete") {
                for index in selectedIndices {
                    do {
                        let result = lungMeasurements[index]
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
        LungCapacityResultsListScreen(for: UUID())
    }
}
