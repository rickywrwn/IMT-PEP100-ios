//
//  getExerciseResultDescription.swift
//  MEP
//
//  Created by Nathan Getachew on 5/9/24.
//

import Foundation
func getExerciseResultDescription(for accuracy: Int) -> String {
    // - Less than 60%: It takes a lot of exercise! - 61-70% : I need a little more exercise! - 71-80%: Not bad! - 81-90%: It's a little good! - 91-100%: Very good!
    if accuracy < 60 {
        return "exercise-result-very-bad"
    } else if accuracy >= 61 && accuracy <= 70 {
        return "exercise-result-bad"
    } else if accuracy >= 71 && accuracy <= 80 {
        return "exercise-result-not-bad"
    } else if accuracy >= 81 && accuracy <= 90 {
        return "exercise-result-good"
    } else {
        return "exercise-result-very-good"
    }
}
