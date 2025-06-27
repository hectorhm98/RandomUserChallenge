//
//  RandomUserApiClientMock.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 27/6/25.
//

@testable import RandomUserChallenge

final class RandomUserAPIClientMock: RandomUserAPIClient {
    var fetchCalled = false
    var usersToReturn: [RandomUserDTO] = []

    func fetchRandomUsers(resultSize: Int) async throws -> [RandomUserDTO] {
        fetchCalled = true
        return usersToReturn
    }
}
