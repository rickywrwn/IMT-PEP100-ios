//
//  EnduranceAccuracy.swift
//  MEP
//
//  Created by Nathan Getachew on 5/21/24.
//

import SwiftUI

 extension EnduranceExerciseMeasurementScreen {
     //MARK: -  MIP
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
    
     //MARK: - MEP
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
    
     //MARK: - REST
    
     var totalRestMeasurementsCount: Int {
         2 * measurementsPerSecond * Int(restTime) * numberOfSets
     }
    
     var restAccuracy: Int {
         let acc: Double = Double(accurateRestMeasurementsCount)  / Double(totalRestMeasurementsCount) * 100
         return min(Int(acc),100)
     }
    
    
     //MARK: - total accuracy
     var accuracy: Int {

         let acc: Double = (Double(mipAccuracy) + Double(mepAccuracy) + Double(restAccuracy)) / 3
         return min(Int(acc),100)
     }
        
 }


