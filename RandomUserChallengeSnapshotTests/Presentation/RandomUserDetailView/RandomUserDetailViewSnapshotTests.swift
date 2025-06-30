//
//  RandomUserDetailViewSnapshotTests.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 30/6/25.
//

import SwiftUI
import SnapshotTesting
import Testing

@testable import RandomUserChallenge

@MainActor
struct RandomUserDetailViewSnapshotTests {
    init() async throws {
    }

    @Test func test_RandomUserDetailView() async {
        let view = RandomUserDetailView(user: FakeRandomUserFactory.generate(count: 1).first!, onDelete: {})
        assertAllSnapshots(of: view, named: "RandomUserDetailView")
    }
}
