//
//  ExercisesResultsListScreen.swift
//  MEP
//
//  Created by Nathan Getachew on 2/6/24.
//

import SwiftUI

struct ExerciseTypeList: Identifiable{
    var id = UUID()
    var name: String
    var date: Date
    var type: String
    var isSelected: Bool = false
}

struct ExercisesResultsListScreen: View {
    @Environment(\.managedObjectContext) private var moc
    @EnvironmentObject var navStore: NavigationStore
    let grayCellBg : Color = .gray.opacity(0.3)
    
    private var exerciseResultsFetchRequest : FetchRequest<ExerciseResult>
    private var exerciseResults: FetchedResults<ExerciseResult> {
        exerciseResultsFetchRequest.wrappedValue
    }
    
    @State private var selectedIndices: [Int] = []
    @State private var isDeletionConfirmationPopupVisible = false
    
    init(for userId: UUID){
        exerciseResultsFetchRequest = FetchRequest(
            sortDescriptors: [],
            predicate: NSPredicate(format: "ANY user.id == %@",userId as CVarArg ))
    }
        var body: some View {
            
            VStack(spacing: 0) {
                Grid(horizontalSpacing: 0){
                    GridRow {
                        Text("number")
                            .modifyCell(backgroundColor: grayCellBg, foregroundColor: .redAccent)
                        Text("name")
                            .modifyCell(backgroundColor: grayCellBg, foregroundColor: .redAccent)
                        Text("date")
                            .modifyCell(backgroundColor: grayCellBg, foregroundColor: .redAccent)
                        Text("type")
                            .modifyCell(backgroundColor: grayCellBg, foregroundColor: .redAccent)
                        Text("select")
                            .modifyCell(backgroundColor: grayCellBg, foregroundColor: .redAccent)
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
                        
                        ForEach(exerciseResults.indices, id: \.self) { index in
                            let result = exerciseResults[index]
                            let isSelected = selectedIndices.contains(index)
                            GridRow {
                                Text("\(index + 1)")
                                
                                Text((result.createdAt ?? .now)
                                    .formatted(date: .numeric, time: .shortened))
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                
                                Text(result.user?.name ?? "")
                                    .lineLimit(1)
                                
                                Text(LocalizedStringKey(ExerciseType(rawValue: result.exerciseType)?.title ?? ""))
                                    .multilineTextAlignment(.center)
                                
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
                    .foregroundColor(.redAccent)
                }
                
                Spacer()
                
                HStack(spacing: 4){
                    GridRowButton(
                        title: "delete",
                        backgroundColor: .redAccent,
                        disabled: selectedIndices.isEmpty
                    ){
                        isDeletionConfirmationPopupVisible = true
                    }
                    GridRowButton(
                        title:"breathing-exercise",
                        backgroundColor: .redAccent
                    ){
                        navStore.path.removeLast(navStore.path.count - 1)
                    }
                    
                    GridRowButton(
                        title: "check",
                        backgroundColor: .redAccent,
                        disabled: selectedIndices.count != 1
                    ){
                        if let measurement = exerciseResults[safe: selectedIndices.first ?? 0] {
                            navStore.path.append(Screens.exerciseResultsScreen(measurement.id ?? UUID()))
                        }
                    }
    //                .disabled(selectedIndices.count != 1)

                }
                .fixedSize(horizontal: false, vertical: true)
                .padding([.horizontal, .bottom])
                .padding(.top, 4)


            }
            
             .navBar(title: "list-of-breathing-exercises", backgroundColor: .redAccent)
            .fullScreenCover(isPresented: $isDeletionConfirmationPopupVisible) {
                UserDeletionConfirmationPopup(label: "sure-to-delete") {
                    for index in selectedIndices {
                        do {
                            let result = exerciseResults[index]
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
        ExercisesResultsListScreen(for: UUID())
    }
}



//VStack {
//    
//    LazyVGrid(columns: [
//        GridItem(.flexible(), spacing: 0),
//        GridItem(.flexible(), spacing: 0),
//        GridItem(.flexible(), spacing: 0),
//        GridItem(.flexible(), spacing: 0),
//        GridItem(.flexible(), spacing: 0),
//    ]){
//
//            GridRow {
//                Text("number")
//                    .modifyCell(backgroundColor: grayCellBg, foregroundColor: .accent)
//                Text("name")
//                    .modifyCell(backgroundColor: grayCellBg, foregroundColor: .accent)
//                Text("date")
//                    .modifyCell(backgroundColor: grayCellBg, foregroundColor: .accent)
//                Text("type")
//                    .modifyCell(backgroundColor: grayCellBg, foregroundColor: .accent)
//                Text("select")
//                    .modifyCell(backgroundColor: grayCellBg, foregroundColor: .accent)
//            }
//            .multilineTextAlignment(.center)
//        
//        ForEach(results.indices, id: \.self) { index in
//            let result = results[index]
//            GridRow {
//                Text("\(index + 1)")
//                Text(result.name)
//                    .lineLimit(1)
//                Text(result.date, style: .date)
//                Text(result.type)
//                Group {
//                    if result.isSelected {
//                        Image(systemName: "checkmark.square.fill")
//                    } else {
//                        Image(systemName: "square")
//                    }
//                }
//                .onTapGesture {
//                    results[index].isSelected.toggle()
//                }
//                .font(.title3)
//            }
//        }
//    }
//    Spacer()
//
//    HStack{
//        Button(action: {}) {
//            Text("delete")
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.redAccent)
//                .foregroundColor(.white)
//        }
//        Button(action: {}) {
//            Text("breathing-exercise")
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.redAccent)
//                .foregroundColor(.white)
//        }
//        Button(action: {}) {
//            Text("check")
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.redAccent)
//                .foregroundColor(.white)
//        }
//    }
//    .padding([.bottom, .horizontal])
//    
//    
//}
