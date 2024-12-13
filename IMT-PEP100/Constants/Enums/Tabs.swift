//
//  Tabs.swift
//  MEP
//
//  Created by Nathan Getachew on 3/4/24.
//

import Foundation

enum Tabs {
    case breathWorkout
    case respiratoryMeasurement
    case lungMeasurement
    
    var title: String {
        switch self {
            
        case .breathWorkout:
            "breath-workout"
        case .respiratoryMeasurement:
            "respiratory-measurement-multiline"
        case .lungMeasurement:
            "lung-measurement"
        }
    }
    
    var screen: Screens {
        switch self {
            
        case .breathWorkout:
            Screens.chooseExercise
        case .respiratoryMeasurement:
            Screens.respiratoryMeasurement
        case .lungMeasurement:
            Screens.lungMeasurement
        }
    }
    
    var localizedKey: String.LocalizationValue {
        String.LocalizationValue(stringLiteral: self.title)
    }
}
