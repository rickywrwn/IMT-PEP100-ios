//
//  predFEV1.swift
//  MEP
//
//  Created by Nathan Getachew on 4/26/24.
//

import Foundation

func predictedFEV1(race: Race, gender: Gender, height: Double, age: Double ) -> Double{
    switch race {
    case .asian:
        switch gender {
        case .male:
            //male : -3.4132 -0.0002484*age^2 (year) + 0.04578*height (cm)
            return -3.4132 - 0.0002484 * pow(age,2) + 0.04578 * height
        case .female:
            //female : -2.4114 - 0.0001920*age^2 (year) + 0.03558*height (cm)
            return -2.4114 - 0.0001920 * pow(age,2) + 0.03558 * height
        }
        
    case .western:
        switch gender {
        case .male:
            //male : height (cm)*0.092*0.03937 – age*0.032 – 1.26
            return height * 0.092 * 0.03937 - age * 0.032 - 1.26
        case .female:
            //female : height (cm)*0.089*0.03937 – age*0.025 – 1.932
            return height * 0.089 * 0.03937 - age * 0.025 - 1.932
        }
    }
}

