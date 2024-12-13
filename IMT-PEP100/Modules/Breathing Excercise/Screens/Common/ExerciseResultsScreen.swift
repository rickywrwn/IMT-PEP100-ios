//
//  ExerciseResultsScreen.swift
//  MEP
//
//  Created by Nathan Getachew on 2/7/24.
//

import SwiftUI

struct ExerciseResultsScreen: View {
    @EnvironmentObject var navStore: NavigationStore
    private var exerciseResultFetchRequest : FetchRequest<ExerciseResult>
    private var exerciseResult: FetchedResults<ExerciseResult> {
        exerciseResultFetchRequest.wrappedValue
    }
    private var exercise: ExerciseResult? {
        exerciseResult.first
    }
    init(id: UUID){
        exerciseResultFetchRequest = FetchRequest(
            sortDescriptors: [],
            predicate: NSPredicate(format: "id == %@", id as CVarArg ))
        
    }
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isSelected == %@", NSNumber(value: true)))
    var selectedUser: FetchedResults<User>
    
    @State private var height : CGFloat = 0
    @State private var progress : Double = 0.5
    
    let cellBg = Color(red: 228/255, green: 163/255, blue: 152/255)
    var body: some View {
        VStack(spacing : 48) {
            ZStack {
                let progress = Double(exercise?.accuracy ?? 0) / 100
                CircularProgressView(progress: progress)
                    .padding(.horizontal, 120)
                Text("\(Int(progress*100))%")
            }
            
            
            VStack(spacing: 8) {
                VStack(alignment: .leading) {
                    Text("result")
                    let descriptionKey = getExerciseResultDescription(for: Int(exercise?.accuracy ?? 0))
                    Text(LocalizedStringKey(descriptionKey))
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .foregroundColor(.white)
                .background(.redAccent)
                
                    HStack(spacing: 8) {
                        VStack(spacing: 8) {
                            VStack(alignment: .leading) {
                                Text("exercise-mode")
                                Text(LocalizedStringKey(ExerciseType(rawValue: exercise?.exerciseType ?? 0)?.title ?? ""))
                                    .font(.headline)
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                
                            }
                            .padding()
                            .background(cellBg)
                            
                            VStack(alignment: .leading) {
                                Text("pressure")
                                Text("MIP \(Int(exercise?.mip ?? 0)) / MEP \(Int(exercise?.mep ?? 0))")
                                    .font(.headline)
                                    .bold()
                                    .frame(maxWidth: .infinity)
                            }
                            .padding()
                            .background(cellBg)
                            
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading) {
                            let minutes = (exercise?.totalTime ?? 0) / 60
                            let seconds = (exercise?.totalTime ?? 0) % 60
                            Text("exercise-time")
                            Spacer()
                            Text(
                                String(format: "%02i", minutes) +
                                " : " +
                                String(format: "%02i", seconds)
                            )
                                .font(.largeTitle)
                            Spacer()
                        }
                        .padding()
                        .frame(maxHeight: .infinity)
                        .background(cellBg)
                    }

                    .fixedSize(horizontal: false, vertical: true)
            }
            
            
            HStack {
                Button {
                    navStore.path.removeLast(navStore.path.count - 1)
                } label: {
                     Text("start")
                        .padding()
                        .padding(.horizontal)
                        .background(.redAccent)
                        .foregroundColor(.white)
                        
                }
                Button {
                    navStore.path.append(Screens.exerciseResultsListScreen(selectedUser.first?.id ?? UUID()))
                    
                } label: {
                     Text("list")
                        .padding()
                        .padding(.horizontal)
                        .background(.redAccent)
                        .foregroundColor(.white)
                        
                }
            }
            
            
        }
        .padding()
        .navBar(title: "exercise-results", backgroundColor: .redAccent)
        .toolbar {
            ToolbarItem {
                SelectedProfileView(selectedUser: selectedUser.first)
                
            }
        }
    }
}

#Preview {
    NavigationView {
        ExerciseResultsScreen(id: UUID())
    }
}
