//
//  LungCapacityResultsChartPlaceHolder.swift
//  MEP
//
//  Created by Nathan Getachew on 4/21/24.
//

import SwiftUI
import Charts

struct LungCapacityResultsChartPlaceHolder: View {
    var body: some View {
        Chart{
            ForEach(0..<7, id: \.self) { i in
                LineMark(x: .value("time", i), y: .value("capacity", i))
                    .lineStyle(.init(lineWidth: 0))
            }
        }
        .chartXAxisLabel("Volume(L)", alignment: .trailing)
        .chartYAxisLabel("Flow(L/s)", alignment: .leading)
        .chartYAxis{
            AxisMarks(position: .leading, values: [0,2,4,6,8,10]) { value in
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
    LungCapacityResultsChartPlaceHolder()
}
