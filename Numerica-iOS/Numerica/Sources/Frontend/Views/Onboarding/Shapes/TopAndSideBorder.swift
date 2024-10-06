//
//  TopAndSideBorder.swift
//  Numerica
//
//  Created by Emil Shpeklord on 06.10.2024.
//

import SwiftUI

struct TopAndSideBorder: Shape {
    var cornerRadius: CGFloat
    
    func path(
        in rect: CGRect
    ) -> Path {
        var path = Path()
        
        path
            .move(
                to: CGPoint(
                    x: rect.minX,
                    y: rect.minY + cornerRadius
                )
            )
    
        path
            .addArc(
                center: CGPoint(
                    x: rect.minX + cornerRadius,
                    y: rect.minY + cornerRadius
                ),
                radius: cornerRadius,
                startAngle:
                        .degrees(
                            180
                        ),
                endAngle:
                        .degrees(
                            270
                        ),
                clockwise: false
            )
        
        path
            .addLine(
                to: CGPoint(
                    x: rect.maxX - cornerRadius,
                    y: rect.minY
                )
            )
        
        path
            .addArc(
                center: CGPoint(
                    x: rect.maxX - cornerRadius,
                    y: rect.minY + cornerRadius
                ),
                radius: cornerRadius,
                startAngle:
                        .degrees(
                            270
                        ),
                endAngle:
                        .degrees(
                            0
                        ),
                clockwise: false
            )
        
        path
            .addLine(
                to: CGPoint(
                    x: rect.maxX,
                    y: rect.maxY
                )
            )
        
        path
            .move(
                to: CGPoint(
                    x: rect.minX,
                    y: rect.minY + cornerRadius
                )
            )
        path
            .addLine(
                to: CGPoint(
                    x: rect.minX,
                    y: rect.maxY
                )
            )
        
        return path
    }
}

