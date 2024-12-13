//
//  EnduranceUIValues.swift
//  MEP
//
//  Created by Nathan Getachew on 5/21/24.
//

import SwiftUI

extension EnduranceExerciseMeasurementScreen {
    var ratio: CGFloat { CGFloat(currentMeasurementElapsedTime) / CGFloat(currentMeasurementTotalTime)
    }
    
    // MARK: -
    var offSetX: CGFloat {
        if  currentMeasurement == .mip {
            min( (ratio * width) - 12 , width - 22)
        } else if currentMeasurement == .mep {
            width - (ratio * width) - 12
        } else if elapsedSectionTime <= timePerSectionMIP + restTime {
            width - 22
        } else {
            -12
        }
    }
    
    //MARK: -
    var offSetY : CGFloat {
        
        if currentMeasurement == .mip {
            -12
        } else if currentMeasurement == .mep  {
            width - 22
        } else if elapsedSectionTime <= timePerSectionMIP + restTime {
            min(ratio * width, width - 22)
        } else {
            max(-12, width - (ratio * width) - 12)
        }
    }
    
    var scale: CGFloat {
        
        if currentMeasurement == .mip {
            0.5 + (ratio * 0.5)
        } else if currentMeasurement == .mep {
            0.5 + (1 - ratio) * 0.5
        } else if elapsedSectionTime <= timePerSectionMIP + restTime {
            1
        } else {
            0.5
        }
    }
    
    
    //     var scalePressure: CGFloat {
    //         if currentMeasurement == .mip {
    //             min(0.5 + (CGFloat(maxMipMeasurements[safe: mipCount] ?? 0) / CGFloat(adjustedMIP) * 0.5), 1)
    //         } else if currentMeasurement == .mep {
    //             max(0.5 + (1 - (CGFloat(maxMepMeasurements[safe: mepCount] ?? 0) / CGFloat(adjustedMEP))) * 0.5, 0.5)
    //         } else if elapsedSectionTime <= timePerSectionMIP + restTime {
    //             1
    //         } else {
    //             0.5
    //         }
    //     }
    var scalePressure: CGFloat {
                 if currentMeasurement == .mip {
                     return 0.5 + ( min(CGFloat(abs(lastMeasurement)), CGFloat(adjustedMIP)) / CGFloat(adjustedMIP) * 0.5)
                 } else if currentMeasurement == .mep {
                     return 1 - (min(CGFloat(abs(lastMeasurement)), CGFloat(adjustedMEP)) / CGFloat(adjustedMEP) * 0.5)
                 } else if elapsedSectionTime <= timePerSectionMIP + restTime {
                     return 1 - (min(CGFloat(abs(lastMeasurement)), CGFloat(adjustedMEP)) / CGFloat(adjustedMEP) * 0.5)
                 } else {
                     return 0.5 + ( min(CGFloat(abs(lastMeasurement)), CGFloat(adjustedMIP)) / CGFloat(adjustedMIP) * 0.5)
                 }

    }
}

