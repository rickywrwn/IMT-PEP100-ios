//
//  RespiratoryResultsChart.swift
//  MEP
//
//  Created by Nathan Getachew on 2/1/24.
//

import SwiftUI
import Charts

struct MIPColors {
    static let one = Color.red
    static let two = Color.blue
    static let three = Color.green
}

struct MEPColors {
    static let one = Color.orange
    static let two = Color.purple
    static let three = Color.brown
}
struct RespiratoryResultsChart: View {
    var mipMeasurements: [[MeasurementData]] = []
    var mepMeasurements: [[MeasurementData]] = []
    //MARK: - mip individual measurements
    var mipMeasurement1: [MeasurementData] {
        mipMeasurements[safe: 0] ?? []
    }
    
    var mipMeasurement2: [MeasurementData] {
        mipMeasurements[safe: 1] ?? []
    }
    
    var mipMeasurement3: [MeasurementData] {
        mipMeasurements[safe: 2] ?? []
    }
    
    //MARK: - mep individual measurements
    var mepMeasurement1: [MeasurementData] {
        mepMeasurements[safe: 0] ?? []
    }
    
    var mepMeasurement2: [MeasurementData] {
        mepMeasurements[safe: 1] ?? []
    }
    
    var mepMeasurement3: [MeasurementData] {
        mepMeasurements[safe: 2] ?? []
    }
    
    var body: some View {
        Chart{
            ForEach(mipMeasurement1.indices, id: \.self) {  index in
                let startDate = mipMeasurement1.first?.date ?? .now
                let durationPoints = mipMeasurement1.map { result in
                    result.date.timeIntervalSince(startDate)
                }
                LineMark(
                    x: .value("time", durationPoints[index]),
                    y: .value("capacity", mipMeasurement1[index].value),
                    series: .value("", "mip1")
                )
                .lineStyle(.init(lineWidth: 3))
                .interpolationMethod(.monotone)
                .foregroundStyle(MIPColors.one)
            }
            
            ForEach(mipMeasurement2.indices, id: \.self) {  index in
                let startDate = mipMeasurement2.first?.date ?? .now
                let durationPoints = mipMeasurement2.map { result in
                    result.date.timeIntervalSince(startDate)
                }
                LineMark(
                    x: .value("time", durationPoints[index]),
                    y: .value("capacity", mipMeasurement2[index].value),
                    series: .value("", "mip2")
                )
                .lineStyle(.init(lineWidth: 3))
                .interpolationMethod(.monotone)
                .foregroundStyle(MIPColors.two)
            }
            
            ForEach(mipMeasurement3.indices, id: \.self) {  index in
                let startDate = mipMeasurement3.first?.date ?? .now
                let durationPoints = mipMeasurement3.map { result in
                    result.date.timeIntervalSince(startDate)
                }
                LineMark(
                    x: .value("time", durationPoints[index]),
                    y: .value("capacity", mipMeasurement3[index].value),
                    series: .value("", "mip3")
                )
                .lineStyle(.init(lineWidth: 3))
                .interpolationMethod(.monotone)
                .foregroundStyle(MIPColors.three)
            }
            
            ForEach(mepMeasurement1.indices, id: \.self) {  index in
                let startDate = mepMeasurement1.first?.date ?? .now
                let durationPoints = mepMeasurement1.map { result in
                    result.date.timeIntervalSince(startDate)
                }
                LineMark(
                    x: .value("time", durationPoints[index]),
                    y: .value("capacity", mepMeasurement1[index].value),
                    series: .value("", "mep1")
                )
                .lineStyle(.init(lineWidth: 3))
                .interpolationMethod(.monotone)
                .foregroundStyle(MEPColors.one)
            }

            ForEach(mepMeasurement2.indices, id: \.self) {  index in
                let startDate = mepMeasurement2.first?.date ?? .now
                let durationPoints = mepMeasurement2.map { result in
                    result.date.timeIntervalSince(startDate)
                }
                LineMark(
                    x: .value("time", durationPoints[index]),
                    y: .value("capacity", mepMeasurement2[index].value),
                    series: .value("", "mep2")
                )
                .lineStyle(.init(lineWidth: 3))
                .interpolationMethod(.monotone)
                .foregroundStyle(MEPColors.two)
            }

            ForEach(mepMeasurement3.indices, id: \.self) {  index in
                let startDate = mepMeasurement3.first?.date ?? .now
                let durationPoints = mepMeasurement3.map { result in
                    result.date.timeIntervalSince(startDate)
                }
                LineMark(
                    x: .value("time", durationPoints[index]),
                    y: .value("capacity", mepMeasurement3[index].value),
                    series: .value("", "mep3")
                )
                .lineStyle(.init(lineWidth: 3))
                .interpolationMethod(.monotone)
                .foregroundStyle(MEPColors.three)
            }
            
        }
//        .chartXScale(domain: 0...8)
        .chartXAxisLabel("Time(s)", alignment: .trailing)
        .chartYAxisLabel("cmH₂0", alignment: .leading)
        .chartYAxis{
            AxisMarks(position: .leading, values: .automatic) { value in
                AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
                AxisValueLabel() {
                    if let intValue = value.as(Int.self) {
                        Text("\(intValue)")
                            .font(.system(size: 10))
                    }
                }
            }
        }
        .chartXAxis{
            AxisMarks(preset: .aligned, values: [0,1,2,3,4,5,6,7]) { value in
                AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
                AxisValueLabel()
            }
        }
        .padding(.trailing, 12 )
        .background(.chartBackground)
        .frame(height: 300)
        
    }
}

#Preview {
    RespiratoryResultsChart(
        mipMeasurements: [
            [
                .init(date: Date(), value: 10),
                .init(date: Calendar.current.date(byAdding: .second, value: 1, to: .now) ?? .now, value: 13),
                .init(date: Calendar.current.date(byAdding: .second, value: 7, to: .now) ?? .now, value: 3)
                
            ],            [
                .init(date: Date(), value: 30),
                .init(date: Calendar.current.date(byAdding: .second, value: 2, to: .now) ?? .now, value: 20),
                .init(date: Calendar.current.date(byAdding: .second, value: 4, to: .now) ?? .now, value: 2)
                
            ],
            [
                .init(date: Date(), value: 1),
                .init(date: Calendar.current.date(byAdding: .second, value: 2, to: .now) ?? .now, value: 10),
                .init(date: Calendar.current.date(byAdding: .second, value: 4, to: .now) ?? .now, value: 2)
            ]
            
        ],
        mepMeasurements: [
            [
                .init(date: Date(), value: -10),
                .init(date: Calendar.current.date(byAdding: .second, value: 1, to: .now) ?? .now, value: -13),
                .init(date: Calendar.current.date(byAdding: .second, value: 2, to: .now) ?? .now, value: -1)
                
            ],
            [
                .init(date: Date(), value: -1),
                .init(date: Calendar.current.date(byAdding: .second, value: 2, to: .now) ?? .now, value: -10),
                .init(date: Calendar.current.date(byAdding: .second, value: 4, to: .now) ?? .now, value: -2)
                
            ],
            [
                .init(date: Date(), value: -10),
                .init(date: Calendar.current.date(byAdding: .second, value: 2, to: .now) ?? .now, value: -20),
                .init(date: Calendar.current.date(byAdding: .second, value: 4, to: .now) ?? .now, value: -2)
                
            ]
        ]
    )
}
