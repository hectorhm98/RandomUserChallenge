//
//  RandomUserRepositoryImpl.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 26/6/25.
//

final class RandomUserRepositoryImpl: RandomUserRepository {
    private let api: RandomUserAPIClient
    private let pageSize = 20

    init(api: RandomUserAPIClient) {
        self.api = api
    }

    func fetchUsers(page: Int, pageSize: Int) async throws -> [RandomUser] {
        let localUsers = try await api.fetchRandomUsers(resultSize: pageSize)
        return localUsers.map(RandomUserMapper.map)
    }
}
