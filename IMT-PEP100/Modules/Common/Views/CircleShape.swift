//
//  CircleShape.swift
//  MEP
//
//  Created by Nathan Getachew on 3/8/24.
//

import SwiftUI


struct CircleShape: Shape {
    func path(in rect: CGRect) -> Path {
        let r = rect.height / 2 * 1.6
        let center = CGPoint(x: rect.midX, y: rect.midY * 1.5)
        var path = Path()
        path.addArc(center: center, radius: r,
                    startAngle: Angle(degrees: 140), endAngle: Angle(degrees: 40), clockwise: false)
        path.closeSubpath()
        return path
    }
}
