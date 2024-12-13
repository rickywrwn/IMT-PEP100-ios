//
//  diagnoseResults.swift
//  MEP
//
//  Created by Nathan Getachew on 4/28/24.
//

import Foundation


func diagnoseResults(fvc: Double, fev1: Double) -> LungDiagnosticResult {
    let fev1_to_fvc_ratio: Double = fvc > 0 ?  fev1 / fvc : 0
    if fev1_to_fvc_ratio >= 70 {
        if fvc >= 80 {
            if fev1 >= 80 {
                return .normal
            } else {
                return .suspectedCOPD
            }
            
        } else {
            return .suspectedRestrictiveLungDisease
        }
        
    } else {
        if fvc >= 80 {
            return .copd
        } else {
            return .copdWithRestrictiveLungDisease
        }
        
    }
}
