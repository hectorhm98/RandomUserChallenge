//
//  GetRandomUserUseCase.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 27/6/25.
//

protocol GetRandomUsersUseCase {
    func execute(offset: Int, batchSize: Int) async throws -> [RandomUser]
}

final class GetRandomUsersUseCaseImpl: GetRandomUsersUseCase {
    private let repository: RandomUserRepository

    init(repository: RandomUserRepository) {
        self.repository = repository
    }

    func execute(offset: Int, batchSize: Int) async throws -> [RandomUser] {
        try await repository.fetchUsers(at: offset, batchSize: batchSize)
    }
}
