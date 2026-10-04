//
//  Pose.swift
//  KinetiaMotion
//
//  Created by Deivy Mejia Ruiz on 4/10/26.
//

import CoreGraphics
import Foundation

/// One frame of body landmarks.
///
///  Contract (the adapter that poses must respect it):
///   - Coordinates are in image pixels, with y growing **downward**
///   - Sides are **
public struct Pose: Sendable {
    public var points: [Joint: CGPoint]
    public var timestamp: TimeInterval
    
    public init(points: [Joint: CGPoint], timestamp: TimeInterval) {
        self.points = points
        self.timestamp = timestamp
    }
    
    public subscript(joint: Joint) -> CGPoint? {
        points[joint]
    }
}
