//
//  LoadNewUsersForQueryUseCase.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 27/6/25.
//

protocol LoadNewUsersForQueryUseCase {
    func execute(currentQuery: String, batchSize: Int) async throws -> [RandomUser]
}

struct LoadNewUsersForQueryUseCaseImpl: LoadNewUsersForQueryUseCase {
    let repository: RandomUserRepository

    func execute(currentQuery: String, batchSize: Int) async throws -> [RandomUser] {
        _ = try await repository.fetchNewUsers(batchSize: batchSize)
        return try repository.fetchFilteredUsers(by: currentQuery)
    }
}
