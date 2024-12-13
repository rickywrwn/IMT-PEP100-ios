//
//  calculateFlowRate.swift
//  MEP
//
//  Created by Nathan Getachew on 4/25/24.
//

import Foundation

func calculateFlowRate(for pressure: Double) -> Double {
    return ((2.8294 / pow(10,8)) * pow(pressure,3))
    + (-0.000020906 * pow(pressure, 2) )
    + (0.00691133 * pressure)
    + 0.0033016
}
