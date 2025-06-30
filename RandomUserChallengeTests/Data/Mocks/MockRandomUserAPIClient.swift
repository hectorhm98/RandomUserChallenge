//
//  MockRandomUserAPIClient.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 27/6/25.
//

@testable import RandomUserChallenge

final class MockRandomUserAPIClient: RandomUserAPIClient {
    var fetchCalled = 0
    var usersToReturn: [RandomUserDTO] = []

    func fetchRandomUsers(resultSize: Int) async throws -> [RandomUserDTO] {
        fetchCalled += 1
        return usersToReturn
    }
}
