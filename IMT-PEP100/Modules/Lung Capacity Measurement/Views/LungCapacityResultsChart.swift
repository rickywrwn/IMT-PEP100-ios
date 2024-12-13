//
//  LungCapacityResultsChart.swift
//  MEP
//
//  Created by Nathan Getachew on 2/1/24.
//

import SwiftUI
import Charts

struct LungCapacityResultsChart: View {
    
    let results: [MeasurementData]
    
    var volumeData: [Double] {
        results.indices.map { index in
            results[0...index].reduce(0) { $0 + $1.value * 0.1 }
        }
    }
    
    //    var startDate: Date  {
    //        results.first?.date ?? .now
    //    }
    //
    //    var  groupedFlowRates : [[Double]]  {
    //        var array : [[Double]] = []
    //
    //        results.forEach{ result in
    //            // get the time difference between the current and next data point
    //            let seconds = Int(result.date.timeIntervalSince(startDate))
    //
    //            if array[safe: seconds] != nil {
    //                array[seconds].append(result.value)
    //            } else {
    //                array.append([result.value])
    //            }
    //
    //        }
    //        return array
    //    }
    //
    //    var volumeValues: [Double]   {
    //        var array: [Double] = []
    //        groupedFlowRates.forEach { group in
    //            array.append(
    //                group.reduce(0){
    //                    $0 + ($1 * 1/Double(group.count) )
    //                }
    //            )
    //        }
    //        return array
    //    }
    
    
    var body: some View {
        return Chart {
            ForEach(results.indices, id: \.self) {  index in
                if let volume = volumeData[safe: index]{
                    LineMark(
                        x: .value("volume", volume),
                        y: .value("capacity", results[index].value)
                        //                    series: .value("", "mip1")
                    )
                    .lineStyle(.init(lineWidth: 3))
                    .interpolationMethod(.monotone)
                    .foregroundStyle(.orange)
                }
            }
            
        }
        .tint(.orange)
        .chartXAxisLabel("Volume(L)", alignment: .trailing)
        .chartYAxisLabel("Flow(L/s)", alignment: .leading)
        .chartYAxis{
            AxisMarks(position: .leading, values: .automatic) { value in
                AxisGridLine(centered: true, stroke: StrokeStyle(dash: [1, 2]))
                AxisValueLabel()
                //                {
                //                    if let intValue = value.as(Int.self) {
                //                        Text("\(intValue)")
                //                            .font(.system(size: 10))
                //                    }
                //                }
            }
        }
        .chartXAxis{
            AxisMarks(preset: .aligned) { value in
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
    LungCapacityResultsChart(
        results: [
            
            
        ])
}
