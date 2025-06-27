//
//  FilterUsersUseCase.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 27/6/25.
//

protocol FilterRandomUsersUseCase {
    func execute(query: String) throws -> [RandomUser]
}

final class FilterRandomUsersUseCaseImpl: FilterRandomUsersUseCase {
    private let repository: RandomUserRepository

    init(repository: RandomUserRepository) {
        self.repository = repository
    }

    func execute(query: String) throws -> [RandomUser] {
        return try self.repository.fetchFilteredUsers(by: query)
    }
}
