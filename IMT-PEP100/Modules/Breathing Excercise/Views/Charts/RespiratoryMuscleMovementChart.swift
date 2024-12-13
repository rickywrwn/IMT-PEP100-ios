//
//  RespiratoryMuscleMovementChart.swift
//  MEP
//
//  Created by Nathan Getachew on 2/15/24.
//

import SwiftUI
import Charts

struct RespiratoryMuscleMovementChart: View {
    
    var measurements: [Double]
    var predMIP: Int
    var predMEP: Int
    var time: [Int] {
        Array(0..<measurements.count)
    }
    
    var body: some View {
        Chart {
            ForEach(measurements.indices, id: \.self) { index in
                LineMark(
                    x: .value("time", time[safe: index] ?? 0),
                    y: .value("capacity", measurements[index])
                )
                .lineStyle(.init(lineWidth: 5))
                .interpolationMethod(.catmullRom)
                .foregroundStyle(.redAccent)
            }
        }
        .tint(.redAccent)
        .chartXAxisLabel("", alignment: .leading)
        .chartYAxisLabel("", alignment: .leading)
        .chartYAxis{
            AxisMarks(preset: .aligned, values: Array( -predMEP...predMIP)) { value in
//                AxisValueLabel()
//                    .foregroundStyle(.clear)
            }
        }
        .chartXAxis{
        }
        .frame(height: 400)
    }
}

#Preview {
    RespiratoryMuscleMovementChart(
        measurements: [0,2,0],
        predMIP: 0,
        predMEP: 0
    )
}
