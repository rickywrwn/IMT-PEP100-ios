//
//  predFEF_25_to_75.swift
//  MEP
//
//  Created by Nathan Getachew on 4/26/24.
//

import Foundation

func predictedFEF_25_to_75(race: Race, gender: Gender, height: Double, weight: Double, age: Double ) -> Double{
    switch race {
    case .asian:
        switch gender {
        case .male:
            //male : 0.37 − 0.048*age(year) + 0.003*weight (㎏) + 0.029*height (cm)
            return 0.37 - 0.048 * age + 0.003 * weight + 0.029 * height
        case .female:
            //female : 0.74 − 0.041*age(year) + 0.0015*weight (㎏) + 0.023*height (cm)
            return 0.74 - 0.041 * age + 0.0015 * weight + 0.023 * height
        }
        
    case .western:
        switch gender {
        case .male:
            //male : 1.94*height (m) - 0.043* age + 2.7
            return 1.94 * height - 0.043 * age + 2.7
        case .female:
            //female : 1.25*height (m) - 0.034* age + 2.92
            return 1.25 * height - 0.034 * age + 2.92
        }
    }
}

