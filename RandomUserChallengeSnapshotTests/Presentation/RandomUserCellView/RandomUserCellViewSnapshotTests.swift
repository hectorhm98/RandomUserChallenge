//
//  RandomUserCellViewSnapshotTests.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 30/6/25.
//

import SwiftUI
import SnapshotTesting
import Testing

@testable import RandomUserChallenge

@MainActor
struct RandomUserCellViewSnapshotTests {
    init() async throws {

    }

    @Test func test_RandomUserCellView() {
        let view = RandomUserCellView(user: FakeRandomUserFactory.generate(count: 1).first!, isLast: false, onAppear: {}, onTap: {})
        
        assertAllSnapshots(of: view, named: "RandomUserCellView")
    }
}
