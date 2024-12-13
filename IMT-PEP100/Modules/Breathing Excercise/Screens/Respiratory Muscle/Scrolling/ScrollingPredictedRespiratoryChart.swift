//
//  ScrollingPredictedRespiratoryChart.swift
//  MEP
//
//  Created by Nathan Getachew on 5/19/24.
//


import SwiftUI
import Charts

@available(iOS 17.0, *)
struct ScrollingPredictedRespiratoryChart: View {
    var mipTime: Int
    var mepTime: Int
    var restTime: Int
    var numberOfSets: Int
    var measurementsPerSecond: Int
    var predMIP: Int
    var predMEP: Int
    var maxMIP: Int
    var maxMEP: Int
    var progress: Double
    
    var setTime : Int {
        return   mipTime + restTime + mepTime +  restTime
    }
    
    var totalSetTime: Int {
        numberOfSets *  setTime
    }

    var totalTime : Int {
        (totalSetTime * measurementsPerSecond)
        + (restTime * measurementsPerSecond)
    }

    var seconds: [Int] {
        return Array(0...totalTime)
    }
    
    var visibleDomain : Int {
        measurementsPerSecond * ( restTime + mipTime)
    }
    
    var values: [Int] {
        var array = [Int]()
        // append 0 for the first rest time
        for _ in 0..<(restTime * measurementsPerSecond )  {
            array.append(0)
        }
        // go through the sets and append mip first then rest then mep then rest
        for _ in 0..<numberOfSets {
                
                let mipIncrementTime = Int(Double(mipTime * measurementsPerSecond) * 0.2)

            for j in 1...mipIncrementTime {
                    array.append( Int( Double(j) / Double(mipIncrementTime) * Double(predMIP)))
                }
                for _ in 0..<(mipTime * measurementsPerSecond - mipIncrementTime - mipIncrementTime) {
                    array.append(predMIP)
                }

            for j in 1...mipIncrementTime {
                    array.append(predMIP - Int( Double(j) / Double(mipIncrementTime) * Double(predMIP)))
                }
                
//            }
            for _ in 0..<(restTime * measurementsPerSecond ) {
                array.append(0)
            }

            let mepIncrementTime = Int(Double(mepTime * measurementsPerSecond) * 0.2)
            
            for j in 1...mepIncrementTime {
                // array.append(-(predMEP / mepIncrementTime) * j)
               array.append(-Int( Double(j) / Double(mepIncrementTime) * Double(predMEP))) 
            }
            for _ in 0..<(mepTime * measurementsPerSecond - mepIncrementTime - mepIncrementTime) {
                array.append(-predMEP)
            }
            for j in 1...mepIncrementTime {
                array.append(-predMEP + Int( Double(j) / Double(mepIncrementTime) * Double(predMEP)))
            }
            
            
                      


            for _ in 0..<(restTime * measurementsPerSecond ) {
                array.append(0)
            }
        }
        
        return array
    }
    
    private var maxValue: Int {
        max(maxMEP,maxMIP)
    }
    
    @State private var scrollX: Double = 0
    
    
    var body: some View {
        Chart{
            ForEach(values.indices, id: \.self) { index in
                LineMark(
                    x: .value("time", seconds[index]),
                    y: .value("capacity", values[index])
                )
                .lineStyle(.init(lineWidth: 5))
//                .interpolationMethod(.stepEnd)
                .foregroundStyle(.gray)
            }
        }
        .tint(.gray)
        .chartXAxisLabel("", alignment: .leading)
        .chartYAxisLabel("", alignment: .leading)
        .chartYScale(domain: [Int(-maxMEP - 4), Int(maxMIP + 4)])
        .chartXScale(domain: [0,totalTime])
//        .chartYAxis{
//                    AxisMarks(preset: .aligned, values: Array( -maxMEP...maxMIP)) { value in
//                                        AxisValueLabel()
//                                            .foregroundStyle(.black)
//                    }
//                }
        .chartYAxis{
        }

        .chartXAxis{
            
        }
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: visibleDomain)
        .chartScrollPosition(x: $scrollX)
        .frame(height: 400)
        .onChange(of: progress) { val in
            scrollX = (val * Double(totalTime))
            - Double(restTime * measurementsPerSecond)
        }
        .scrollDisabled(true)
        
        
    }
}



