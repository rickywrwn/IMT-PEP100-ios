//
//  fvc.swift
//  MEP
//
//  Created by Nathan Getachew on 4/26/24.
//

import Foundation

func predictedFVC(race: Race, gender: Gender, height: Double, weight: Double, age: Double ) -> Double{
    switch race {
    case .asian:
        switch gender {
        case .male:
            //male : -4.8434 – 0.00008633*age^2 (year) + 0.05292*height(㎝) + 0.01095*weight(㎏)
            return -4.8434 - 0.00008633 * pow(age,2) + 0.05292 * height + 0.01095 * weight
        case .female:
            //female : -3.0006 -0.0001273*age^2 (year) + 0.03951*height(㎝) + 0.006892*weight(㎏)
            return -3.0006 - 0.0001273 * pow(age,2) + 0.03951 * height + 0.006892 * weight
        }
        
    case .western:
        switch gender {
        case .male:
            //male : height(cm)*0.148*0.03937 – age*0.025 – 4.241
            return height * 0.148 * 0.03937 - age * 0.025 - 4.241
        case .female:
            //female : height (cm)*0.115*0.03937 – age*0.024 – 2.852
            return height * 0.115 * 0.03937 - age * 0.024 - 2.852
        }
    }
}


