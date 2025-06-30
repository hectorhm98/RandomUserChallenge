//
//  SnapshotTestsHelpers.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 30/6/25.
//

import SwiftUI
import SnapshotTesting

// MARK: - Helpers
func assertAllSnapshots<V: View>(
    of view: V,
    named name: String,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line
) {
    let devices: [(String, ViewImageConfig)] = [
        ("iPhone SE", .iPhoneSe),
        ("iPhone 13", .iPhone13),
        ("iPad Pro", .iPadPro12_9),
    ]

    for (deviceName, config) in devices {
        assertSnapshot(
            of: view,
            as: .image(layout: .device(config: config)),
            named: "\(name)_\(deviceName)",
            file: file,
            testName: testName,
            line: line,
        )
    }
}
