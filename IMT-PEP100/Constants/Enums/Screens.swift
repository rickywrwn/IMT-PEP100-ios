//
//  Screens.swift
//  MEP
//
//  Created by Nathan Getachew on 3/4/24.
//

import Foundation


enum Screens: Hashable,Codable {

    //MARK: -
    case userRegistration
    
    //MARK: - Respiratory Measurement
    case respiratoryMeasurement
    case respiratoryMeasurementResultsScreen(UUID)
    case respiratoryMeasurementResultsListScreen(UUID)
    
    //MARK: - Respiratory Measurement
    case lungMeasurement
    case lungMeasurementResultsScreen(UUID)
    case lungMeasurementResultsListScreen(UUID)
    
    //MARK: -
    case chooseExercise
    case strengthExerciseScreen
    case enduranceExerciseScreen
    case exerciseSettingsScreen(ExerciseType)
    case exerciseResultsScreen(UUID)
    case exerciseResultsListScreen(UUID)

    
}
