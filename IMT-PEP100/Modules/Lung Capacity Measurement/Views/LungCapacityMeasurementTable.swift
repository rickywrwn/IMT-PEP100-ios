//
//  SpirometryTable.swift
//  MEP
//
//  Created by Nathan Getachew on 2/4/24.
//

import SwiftUI

struct LungCapacityMeasurementTable: View {
    let user : User
    var fvc: Double
    var fev1: Double
    var fev1_to_fvc_ratio: Double
    var fef_25_to_75: Double
    var pef: Double
    var mvv : Double
    
    let predFVC: Double
    let predFEV1: Double
    let predFEF_25_to_75: Double
    let predPEF: Double
    
    init(
        user: User,
        fvc: Double,
        fev1: Double,
        fev1_to_fvc_ratio: Double,
        fef_25_to_75: Double,
        pef: Double,
        mvv : Double
    ) {
        self.user = user
        self.fvc = fvc
        self.fev1 = fev1
        self.fev1_to_fvc_ratio = fev1_to_fvc_ratio
        self.fef_25_to_75 = fef_25_to_75
        self.pef = pef
        self.mvv = mvv
        
        let race = Race(rawValue: Int(user.race)) ?? .asian
        let gender = Gender(rawValue: Int(user.gender)) ?? .male
        let height = Double(user.height)
        let weight = Double(user.weight)
        let age = Double(calculateAge(birthDate: user.birthDate ?? .now))
        
        self.predFVC = predictedFVC(
            race: race,
            gender: gender,
            height: height,
            weight: weight,
            age: age)
        
        self.predFEV1 = predictedFEV1(
            race: race,
            gender: gender,
            height: height,
            age: age)
        
        self.predFEF_25_to_75 = predictedFEF_25_to_75(
            race: race,
            gender: gender,
            height: height,
            weight: weight,
            age: age)
        
        self.predPEF = predictedPEF(
            race: race,
            gender: gender,
            height: height,
            age: age)
        
    }
    
    
    var body: some View {
        Grid(horizontalSpacing: 12, verticalSpacing: 12) {
            
            GridRow {
                Text("")
                Text("")
                HStack {
                    Spacer()
                    Text("measurement")
                        .foregroundStyle(.greenAccent)
                        .font(.title3)
                        .bold()
                    
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("predicted-value")
                        .foregroundStyle(.greenAccent)
                        .font(.title3)
                        .bold()
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .gridColumnAlignment(.trailing)
            
            
            GridRow {
                Text("FVC")
                Text("(L)")
                Text("\(fvc, specifier: "%.2f")")
                Text("\(predFVC, specifier: "%.2f")")
            }
            .frame(maxWidth: .infinity)
            .gridColumnAlignment(.trailing)
            
            GridRow {
                Text("FEV1")
                Text("(L)")
                Text("\(fev1, specifier: "%.2f")")
                Text("\(predFEV1, specifier: "%.2f")")
            }
            .frame(maxWidth: .infinity)
            .gridColumnAlignment(.trailing)
            
            GridRow {
                Text("FEV1/FVC")
                Text("(%)")
                Text("\(fev1_to_fvc_ratio, specifier: "%.2f")")
                Text("\(predFEV1/predFVC, specifier: "%.2f")")
            }
            .frame(maxWidth: .infinity)
            .gridColumnAlignment(.trailing)
            
            GridRow {
                Text("FEF25~75%")
                Text("(L/s)")
                Text("\(fef_25_to_75, specifier: "%.2f")")
                Text("\(predFEF_25_to_75, specifier: "%.2f")")
            }
            .frame(maxWidth: .infinity)
            .gridColumnAlignment(.trailing)
            
            GridRow {
                Text("PEF")
                Text("(L/s)")
                Text("\(pef, specifier: "%.2f")")
                Text("\(predPEF, specifier: "%.2f")")
            }
            .frame(maxWidth: .infinity)
            .gridColumnAlignment(.trailing)
            
            GridRow {
                Text("MVV")
                Text("(L/m)")
                Text("\(mvv, specifier: "%.2f")")
                Text("")
            }
            .frame(maxWidth: .infinity)
            .gridColumnAlignment(.trailing)
            
            
        }
    }
}

//#Preview {
//    LungCapacityMeasurementTable()
//}
