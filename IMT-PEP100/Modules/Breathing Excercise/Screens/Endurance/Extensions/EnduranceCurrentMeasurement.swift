//
//  EnduranceCurrentMeasurement.swift
//  MEP
//
//  Created by Nathan Getachew on 5/21/24.
//

import SwiftUI

 extension EnduranceExerciseMeasurementScreen {
     var currentMeasurement: ExerciseMeasurementType? {
         if elapsedSectionTime <= timePerSectionMIP {
             return .mip
         } else if elapsedSectionTime <= timePerSectionMIP + restTime {
             return .rest
         } else if elapsedSectionTime <= timePerSectionMIP + restTime + timePerSectionMEP {
             return .mep
         } else if elapsedSectionTime <= timePerSectionMIP + restTime + timePerSectionMEP + restTime {
             return .rest
         } else {
             return nil
         }
     }
    
     var currentMeasurementElapsedTime: Double {
         if elapsedSectionTime <= timePerSectionMIP {
             return elapsedSectionTime
         } else if elapsedSectionTime <= timePerSectionMIP + restTime {
             return elapsedSectionTime - timePerSectionMIP
         } else if elapsedSectionTime <= timePerSectionMIP + restTime + timePerSectionMEP {
             return elapsedSectionTime - (timePerSectionMIP + restTime)
         } else if elapsedSectionTime <= timePerSectionMIP + restTime + timePerSectionMEP + restTime {
             return elapsedSectionTime - (timePerSectionMIP + restTime + timePerSectionMEP)
         } else {
             return 0
         }
     }
    
    
     var currentMeasurementTotalTime: Double {
         switch currentMeasurement {
         case .mip:
             return timePerSectionMIP
         case .mep:
             return timePerSectionMEP
         case .rest:
             return restTime
         case nil:
             return 0
         }
     }
    
     var  currentMeasurementProgress: Double { Double( currentMeasurementElapsedTime) / Double(currentMeasurementTotalTime)
     }
    
     var instruction: String {
         switch currentMeasurement {
         case .mip:
             "breath-in"
         case .mep:
             "breath-out"
         case .rest:
             "hold"
            
         default:
             " "
         }
     }
 }
