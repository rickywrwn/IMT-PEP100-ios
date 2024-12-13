//
//  predPEF.swift
//  MEP
//
//  Created by Nathan Getachew on 4/26/24.
//

import Foundation


func predictedPEF(race: Race, gender: Gender, height: Double, age: Double ) -> Double{
    let heightInMeters = height * 0.01
    switch race {
    case .asian:
        switch gender {
        case .male:
            //male : {[(heightInMeters(m) × 5.48) + 1.58] - [age × 0.041]} × 60
            return (((heightInMeters * 0.01 * 5.48) + 1.58) - (age * 0.041)) * 60
        case .female:
            //female : {[(heightInMeters(m) × 3.72) + 2.24] - [age × 0.03]} × 60
            return (((heightInMeters * 0.01 * 3.72) + 2.24) - (age * 0.03)) * 60
        }
        
    case .western:
        switch gender {
        case .male:
            //male : 6.14*heightInMeters (m) - 0.043* age + 0.15
            return 6.14 * heightInMeters - 0.043 * age + 0.15
        case .female:
            //female : 5.5*heightInMeters (m) - 0.03* age - 1.11
            return 5.5 * heightInMeters - 0.03 * age - 1.11
        }
    }
}
