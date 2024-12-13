//
//  RespiratoryPred.swift
//  MEP
//
//  Created by Nathan Getachew on 5/21/24.
//

import SwiftUI

@available(iOS 17.0, *)
extension ScrollingRespiratoryExerciseMeasurementScreen {
    var age: Int {
        calculateAge(birthDate: selectedUser.first?.birthDate ?? .now)
    }
    var predMIP: Int {
        if selectedUser.first!.gender == Gender.male.rawValue {
            return Int(120 - Int(0.41 * Double(age)))
        } else {
            return Int(108 - Int(0.61 * Double(age)))
        }
    }
    
    var adjustedMIP: Int {
        Int(predMIP * pressureRatioMIP / 100)
    }
    
    var predMEP: Int {
        if selectedUser.first!.gender == Gender.male.rawValue {
            return Int(174 - Int(0.83 * Double(age)))
        } else {
            return Int(131 - Int(0.86 * Double(age)))
        }
    }
    
    var adjustedMEP: Int {
        Int(predMEP * pressureRatioMEP / 100)
    }
    

    //    let predMIP = 50
    //    let predMEP = 50
}
