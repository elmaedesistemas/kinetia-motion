//
//  MotionSessionTests.swift
//  KinetiaMotion
//
//  Created by Deivy Mejia Ruiz on 4/10/26.
//

import Foundation
import Testing
@testable import KinetiaMotion

@MainActor
@Suite("MotionSession")
struct MotionSessionTests {
    private func makeSession() -> MotionSession {
        MotionSession(exercise: ExerciseLibrary.elbowFlexion, side: .right, smoothing: 1)
    }

    @Test func runsAProviderToTheEnd() async {
        let session = makeSession()
        await session.run(with: RecordedPoseProvider(oneRep(peak: 120) + oneRep(peak: 130, startingAt: 2)))

        #expect(session.snapshot.repCount == 2)
        #expect(isClose(session.snapshot.best, 130))
        #expect(session.snapshot.isVisible)
        #expect(session.snapshot.isRunning == false)
    }

    @Test func listenersReceiveEventsInOrder() async {
        let session = makeSession()
        var iterator = session.events().makeAsyncIterator()

        await session.run(with: RecordedPoseProvider(oneRep(peak: 120)))

        #expect(await iterator.next() == .visibilityChanged(Visibility(isVisible: true, missingJoints: [])))
        let second = await iterator.next()
        #expect({ if case .repCompleted = second { true } else { false } }())
    }

    @Test func reportsWhatIsMissing() {
        let session = makeSession()
        for frame in 0..<10 {
            session.process(elbowPose(flexion: 40, time: Double(frame) / 24))
        }
        #expect(session.snapshot.isVisible)

        for frame in 10..<20 {
            var pose = elbowPose(flexion: 40, time: Double(frame) / 24)
            pose.points[.rightWrist] = nil
            session.process(pose)
        }
        #expect(session.snapshot.isVisible == false)
        #expect(session.snapshot.missingJoints == [.rightWrist])
    }

    @Test func resetClearsTheCount() async {
        let session = makeSession()
        await session.run(with: RecordedPoseProvider(oneRep(peak: 130)))
        session.reset()

        #expect(session.snapshot.repCount == 0)
        #expect(session.snapshot.best == 0)
    }

    @Test func configureSwitchesExercise() {
        let session = makeSession()
        session.configure(exercise: ExerciseLibrary.kneeFlexionStanding, side: .left)

        #expect(session.exercise.id == "knee.flexion.standing")
        #expect(session.snapshot.missingJoints == [.leftHip, .leftKnee, .leftAnkle])
    }
}
