//
//  EnduranceAccuracy.swift
//  MEP
//
//  Created by Nathan Getachew on 5/21/24.
//

import SwiftUI

@available(iOS 17.0, *)
extension ScrollingRespiratoryExerciseMeasurementScreen {
    
    var minAccurateMip: Double {
        Double(adjustedMIP) * 0.8
    }
    
    var maxAccurateMip: Double {
        Double(adjustedMIP) * 1.2
    }
    
    var totalMipMeasurementsCount: Int {
        measurementsPerSecond * Int(timePerSectionMIP) * numberOfSets
    }
    
    //    var mipAccuracy = 0
    var mipAccuracy: Int {
       let acc: Double = Double(accurateMipMeasurementsCount)  / Double(totalMipMeasurementsCount) * 100
        return  min(Int(acc),100)
    }
    
    //MARK:
    var minAccurateMep: Double {
        Double(adjustedMEP) * 1.2
    }
    
    var maxAccurateMep: Double {
        Double(adjustedMEP) * 0.8
    }
    
    var totalMepMeasurementsCount: Int {
        measurementsPerSecond * Int(timePerSectionMEP) * numberOfSets
    }
    
    //    var mepAccuracy = 0
    var mepAccuracy: Int {
        let acc: Double = Double(accurateMepMeasurementsCount)  / Double(totalMepMeasurementsCount) * 100
        return min(Int(acc),100)
    }
    
    
    //MARK: -
    var accuracy: Int {

        let acc: Double = (Double(mipAccuracy) + Double(mepAccuracy)) / 2
        return min(Int(acc),100)
    }
        
}
