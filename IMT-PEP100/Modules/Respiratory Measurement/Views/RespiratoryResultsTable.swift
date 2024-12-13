//
//  RespiratoryResultsTable.swift
//  MEP
//
//  Created by Nathan Getachew on 2/1/24.
//

import SwiftUI
import Foundation

extension Bool {
    var title: String {
        self ? "YES" : "False"
    }
}

struct RespiratoryResultsTable: View {
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isSelected == %@", NSNumber(value: true)))
    var selectedUser: FetchedResults<User>
    
    @State private var isLLNPopupPresented = false
    @State private var isPredPopupPresented = false
    @State private var isGlossaryPresented = false
    
    let grayCellBg : Color = .gray.opacity(0.2)
    let orangeCellBg: Color = .orange.opacity(0.2)
    let accentCellBg: Color = .blue.opacity(0.2)
    
    var measurement: RespiratoryMeasurement
    
    var age: Int {
        calculateAge(birthDate: selectedUser.first?.birthDate ?? .now)
    }
    //MARK: - Pred
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
    
    //MARK: - LLN
    var mipLLN: Int {
        if selectedUser.first!.gender == Gender.male.rawValue {
            return Int(62 - Int(0.15 * Double(age)))
        } else {
            return Int(62 - Int(0.5 * Double(age)))
        }
    }
    var mepLLN: Int {
        if selectedUser.first!.gender == Gender.male.rawValue {
            return Int(117 - Int(0.83 * Double(age)))
        } else {
            return Int(95 - Int(0.57 * Double(age)))
        }
    }
    
    //MARK: - Per
    var mipPer: Int {
        return Int( (measurement.maxMIP * 100) / Double(mipPred))
    }
    var mepPer: Int {
        return Int( (measurement.maxMEP * 100) / Double(mepPred))
    }
    
    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            
            GridRow {
                HStack{
                    Text("result-analysis")
                    Button {
                        isGlossaryPresented = true
                    } label: {
                        Image(systemName: "questionmark")
                            .padding(.horizontal,6)
                            .padding(.vertical,6)
                            .background(.accent)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                            .font(.callout)
                    }
                }
                Text("MIP")
                    .modifyCell(backgroundColor: .orange,foregroundColor: .white)
                Text("MEP")
                    .modifyCell(foregroundColor: .white)
            }
            
            .frame(maxWidth: .infinity)
            
            GridRow {
                Text("reproducibility")
                Text(measurement.mipReproducibility.title)
                    .modifyCell(
                        backgroundColor: orangeCellBg,
                        foregroundColor:  measurement.mipReproducibility ? .green : .red)
                    .bold()
                Text(measurement.mepReproducibility.title)
                    .modifyCell(
                        backgroundColor: accentCellBg,
                        foregroundColor:  measurement.mepReproducibility ? .green : .red)
                    .bold()
            }
            
            GridRow {
                HStack {
                    Text("Pred")
                    Button {
                        isPredPopupPresented = true
                    } label: {
                        Image(systemName: "ellipsis")
                            .padding(.horizontal,2)
                            .padding(.vertical,6)
                            .background(.accent)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                            .font(.callout)
                    }
                }
                .modifyCell(backgroundColor: grayCellBg)
                Text("\(mipPred)")
                    .modifyCell(backgroundColor: grayCellBg)
                Text("\(mepPred)")
                    .modifyCell(backgroundColor: grayCellBg)
            }
            .frame(maxWidth: .infinity)
            
            GridRow {
                HStack {
                    Text("LLN")
                    Button {
                        isLLNPopupPresented = true
                    } label: {
                        Image(systemName: "ellipsis")
                            .padding(.horizontal,2)
                            .padding(.vertical,6)
                            .background(.accent)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                            .font(.callout)
                    }
                }
                Text("\(mipLLN)")
                    .modifyCell(backgroundColor: orangeCellBg)
                Text("\(mepLLN)")
                    .modifyCell(backgroundColor: accentCellBg)
            }
            .frame(maxWidth: .infinity)
            
            GridRow {
                Text("Per(%)")
                    .modifyCell(backgroundColor: grayCellBg)
                Text("\(mipPer)")
                    .modifyCell(backgroundColor: grayCellBg)
                Text("\(mepPer)")
                    .modifyCell(backgroundColor: grayCellBg)
            }
            .frame(maxWidth: .infinity)
            
            GridRow {
                Text("Age")
                Text(measurement.mipAge.formatted())
                    .modifyCell(backgroundColor: orangeCellBg)
                Text(measurement.mipAge.formatted())
                    .modifyCell(backgroundColor: accentCellBg)
            }
            .frame(maxWidth: .infinity)
            
        }
        .fullScreenCover(isPresented: $isGlossaryPresented) {
            InformationPopup(
                title: "glossary",
                child: AnyView(
                    Text("pred-lln-glossary")
                        .multilineTextAlignment(.leading)
                    
                )) {
                    isGlossaryPresented = false
                }
        }
        .fullScreenCover(isPresented: $isPredPopupPresented) {
            InformationPopup(
                title: "pred-pressure-values",
                child: AnyView(
                    VStack(spacing: 8) {
                        Image("MIP-Table")
                            .resizable()
                            .scaledToFit()
                        Image("MIP-Table")
                            .resizable()
                            .scaledToFit()
                    }
                    
                ),
                confirmLabel: "go-back"
            ) {
                isPredPopupPresented = false
            }
        }
        .fullScreenCover(isPresented: $isLLNPopupPresented) {
            InformationPopup(
                title: "average-lln",
                child: AnyView(
                    VStack(spacing: 8) {
                        Image("MIP-LLN-Table")
                            .resizable()
                            .scaledToFit()
                        Image("MIP-LLN-Table")
                            .resizable()
                            .scaledToFit()
                    }
                    
                ),
                confirmLabel: "go-back"
            ) {
                isLLNPopupPresented = false
            }
        }
    }
}

//#Preview {
//    RespiratoryResultsTable()
//
//}
