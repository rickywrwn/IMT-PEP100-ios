//
//  calculateAge.swift
//  MEP
//
//  Created by Nathan Getachew on 3/8/24.
//

import Foundation

func calculateAge(birthDate: Date) -> Int {
    let currentDate = Date()
    let calendar = Calendar.current
    let ageComponents = calendar.dateComponents([.year], from: birthDate, to: currentDate)
    let age = ageComponents.year!
    return age
}
