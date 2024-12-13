//
//  ScrollingRespiratoryMuscleMovementChart.swift
//  MEP
//
//  Created by Nathan Getachew on 2/15/24.
//

import SwiftUI
import Charts

@available(iOS 17.0, *)
struct ScrollingRespiratoryMuscleMovementChart: View {
    
    var measurements: [Double]
    var maxMIP: Int
    var maxMEP: Int
    var mipTime: Int
    var mepTime: Int
    var restTime: Int
    var numberOfSets: Int
    var measurementsPerSecond: Int
    var progress: Double
    
    var time: [Int] {
        Array(0..<measurements.count)
    }
    private var setTime : Int {
        return   mipTime + restTime + mepTime +  restTime
    }
    
    private var totalSetTime: Int {
        numberOfSets * setTime
    }
    
    private var totalMeasurementsCount: Int {
        (totalSetTime * measurementsPerSecond)
        + (restTime * measurementsPerSecond)
    }
    
    private var visibleDomain: Int {
        measurementsPerSecond * ( restTime + mipTime)
    }
    
    private var maxValue: Int {
        max(maxMEP,maxMIP)
    }
    
    
    @State private var scrollX: Double = 0

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
        .chartYScale(domain: [Int(-maxMEP - 4), Int(maxMIP +  4)])
        .chartXScale(domain: [0,totalMeasurementsCount])
//        .chartYAxis{
//            AxisMarks(preset: .aligned, values: Array( -maxMEP...maxMIP)) { value in
//                //                AxisValueLabel()
//                //                    .foregroundStyle(.clear)
//            }
//        }
        .chartYAxis {
        }
        
        .chartXAxis{
        }
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: visibleDomain )
        .chartScrollPosition(x: $scrollX)
        .frame(height: 400)
        .onChange(of: progress) { val in
            scrollX = ( val  * Double(totalMeasurementsCount))
            - Double(restTime * measurementsPerSecond)
            
        }
        .scrollDisabled(true)
//        .offset(x: progress > 0 ? -CGFloat(visibleDomain) : 0)
//        .offset(y: -30)

    }
}

#Preview {
    RespiratoryMuscleMovementChart(
        measurements: [0,2,0],
        predMIP: 0,
        predMEP: 0
    )
}
