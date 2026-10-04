//
//  TestPoses.swift
//  KinetiaMotion
//
//  Created by Deivy Mejia Ruiz on 4/10/26.
//

import CoreGraphics
import Foundation
@testable import KinetiaMotion

/// Builds a right-arm pose with an exact elbow flexion.
/// `upperArm` = how far the upper arm swings away from hanging straight down.
func elbowPose(flexion: Double, upperArm: Double = 0, time: TimeInterval = 0) -> Pose {
    let r = Double.pi / 180
    let shoulder = CGPoint(x: 0, y: 0)
    let elbow = CGPoint(x: 100 * sin(upperArm * r), y: 100 * cos(upperArm * r))
    let wrist = CGPoint(
        x: elbow.x + 100 * sin((upperArm + flexion) * r),
        y: elbow.y + 100 * cos((upperArm + flexion) * r)
    )
    return Pose(points: [.rightShoulder: shoulder, .rightElbow: elbow, .rightWrist: wrist], timestamp: time)
}

func isClose(_ value: Double?, _ expected: Double) -> Bool {
    guard let value else { return false }
    return abs(value - expected) < 0.001
}
