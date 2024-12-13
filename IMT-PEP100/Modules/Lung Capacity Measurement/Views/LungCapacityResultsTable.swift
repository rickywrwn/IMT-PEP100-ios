//
//  LungCapacityResultsTable.swift
//  MEP
//
//  Created by Nathan Getachew on 2/1/24.
//

import SwiftUI

struct LungCapacityResultsTable: View {
    let darkGrayCellBg : Color = .gray.opacity(0.3)
    let lightGrayCellBg: Color = .gray.opacity(0.1)
    
    //MARK: - measured values
    let fvc: Double
    let fev1: Double
    let fev1_to_fvc_ratio: Double
    let fef_25_to_75: Double
    let pef: Double
    let mvv : Double
    
    //MARK: - predicted values
    let predFVC: Double
    let predFEV1: Double
    let predFEV1_to_FVC_ratio: Double
    let predFEF_25_to_75: Double
    let predPEF: Double
    var predMVV: Double
    
    
    init(
       //MARK: measured values 
        fvc: Double,
        fev1: Double,
        fev1_to_fvc_ratio: Double,
        fef_25_to_75: Double,
        pef: Double,
        mvv : Double,
        
        //MARK: predicted values
        predFVC: Double,
        predFEV1: Double,
        predFEV1_to_FVC_ratio: Double,
        predFEF_25_to_75: Double,
        predPEF: Double,
        predMVV: Double
    ) {
        //MARK: Measured Values 
        self.fvc = fvc
        self.fev1 = fev1
        self.fev1_to_fvc_ratio = fev1_to_fvc_ratio
        self.fef_25_to_75 = fef_25_to_75
        self.pef = pef
        self.mvv = mvv
        //MARK: Predicted Values
        self.predFVC = predFVC
        self.predFEV1 = predFEV1
        self.predFEV1_to_FVC_ratio = predFEV1_to_FVC_ratio
        self.predFEF_25_to_75 = predFEF_25_to_75
        self.predPEF = predPEF
        self.predMVV = predMVV
    }
   
    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            
            GridRow {
                Text("item")
                    .modifyCell(backgroundColor: darkGrayCellBg)
                Text("result")
                    .modifyCell(backgroundColor: darkGrayCellBg)
                Text("predicted-value")
                    .modifyCell(backgroundColor: darkGrayCellBg)
                Text("ratio")
                    .modifyCell(backgroundColor: darkGrayCellBg)
            }

            
            GridRow {
                Text("FVC")
                    .modifyCell(backgroundColor: darkGrayCellBg)
                Text("\(fvc, specifier: "%.2f")")
                    .modifyCell(backgroundColor: lightGrayCellBg)
                Text("\(predFVC, specifier: "%.2f")")
                    .modifyCell(backgroundColor: lightGrayCellBg)
                Text("\(predFVC > 0 ? fvc * 100 / predFVC : 0, specifier: "%.2f")")
                    .modifyCell(backgroundColor: lightGrayCellBg, foregroundColor: .green)
                    .bold()
                }
            
            GridRow {
                Text("FEV1")
                    .modifyCell(backgroundColor: darkGrayCellBg)
                Text("\(fev1, specifier: "%.2f")")
                    .modifyCell(backgroundColor: darkGrayCellBg)
                Text("\(predFEV1, specifier: "%.2f")")
                    .modifyCell(backgroundColor: darkGrayCellBg)
                Text("\(predFEV1 > 0 ? fev1 * 100 / predFEV1 : 0, specifier: "%.2f")")
                    .modifyCell(backgroundColor: darkGrayCellBg, foregroundColor: .green)
                    .bold()
                }
            
            GridRow {
                Text("FEV1/FVC")
                    .modifyCell(backgroundColor: darkGrayCellBg)
                Text("\(fev1_to_fvc_ratio, specifier: "%.2f")")
                    .modifyCell(backgroundColor: lightGrayCellBg)
                Text("\(predFEV1_to_FVC_ratio, specifier: "%.2f")")
                    .modifyCell(backgroundColor: lightGrayCellBg)
                Text("\(predFEV1_to_FVC_ratio > 0 ? fev1_to_fvc_ratio * 100 / predFEV1_to_FVC_ratio : 0, specifier: "%.2f")")
                    .modifyCell(backgroundColor: lightGrayCellBg, foregroundColor: .red)
                    .bold()
                }
            
            GridRow {
                Text("FEF25~75%")
                    .modifyCell(backgroundColor: darkGrayCellBg)
                Text("\(fef_25_to_75, specifier: "%.2f")")
                    .modifyCell(backgroundColor: darkGrayCellBg)
                Text("\(predFEF_25_to_75, specifier: "%.2f")")
                    .modifyCell(backgroundColor: darkGrayCellBg)
                Text("\(predFEF_25_to_75 > 0 ? fef_25_to_75 * 100 / predFEF_25_to_75 : 0, specifier: "%.2f")")
                    .modifyCell(backgroundColor: darkGrayCellBg)
                }
            
            GridRow {
                Text("PEF")
                    .modifyCell(backgroundColor: darkGrayCellBg)
                Text("\(pef, specifier: "%.2f")")
                    .modifyCell(backgroundColor: lightGrayCellBg)
                Text("\(predPEF, specifier: "%.2f")")
                    .modifyCell(backgroundColor: lightGrayCellBg)
                Text("\(predPEF > 0 ? pef * 100 / predPEF : 0, specifier: "%.2f")")
                    .modifyCell(backgroundColor: lightGrayCellBg)
                }
            
            GridRow {
                Text("MVV")
                    .modifyCell(backgroundColor: darkGrayCellBg)
                Text("\(mvv, specifier: "%.2f")")
                    .modifyCell(backgroundColor: darkGrayCellBg)
                Text("\(predMVV, specifier: "%.2f")")
                    .modifyCell(backgroundColor: darkGrayCellBg)
                Text("\(predMVV > 0 ? mvv * 100 / predMVV : 0, specifier: "%.2f")")
                    .modifyCell(backgroundColor: darkGrayCellBg)
                }


        }
    }}

//#Preview {
//    LungCapacityResultsTable()
//}
