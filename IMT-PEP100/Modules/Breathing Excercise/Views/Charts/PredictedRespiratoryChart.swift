//
//  BreathingStrengthTrainingChart.swift
//  MEP
//
//  Created by Nathan Getachew on 2/15/24.
//

import SwiftUI
import Charts

struct PredictedRespiratoryChart: View {
    var mipTime: Int
    var mepTime: Int
    var restTime: Int
    var predMIP: Int
    var predMEP: Int
    var maxMIP: Int
    var maxMEP: Int
    

    var totalTime : Int {
        return Int( restTime + mipTime + restTime + mepTime +  restTime)
    }

    var seconds: [Int] {
        return Array(0...totalTime)
    }

    var values: [Int] {
        return seconds.map { time in
            if time <= restTime {
                return 0
            } else if time <= restTime + mipTime {
                return predMIP
            } else if time <= restTime + mipTime + restTime {
                return 0
            } else if time <= restTime + mipTime + restTime + mepTime {
                return -predMEP
            } else {
                return 0
            } 
        }
    }
    
    

    var body: some View {
        Chart{
            ForEach(values.indices, id: \.self) { index in
                LineMark(
                    x: .value("time", seconds[index]),
                    y: .value("capacity", values[index])
                )
                .lineStyle(.init(lineWidth: 5))
//                .interpolationMethod(.stepStart)
                .foregroundStyle(.gray)
            }
        }
        .tint(.gray)
        .chartXAxisLabel("", alignment: .trailing)
        .chartYAxisLabel("", alignment: .leading)
        .chartYScale(domain: -maxMEP...maxMIP)
        .chartYAxis{
        }
        .chartXAxis{
            
        }

        .frame(height: 400)
    }
}


