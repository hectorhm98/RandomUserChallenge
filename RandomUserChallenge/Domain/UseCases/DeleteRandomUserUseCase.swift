//
//  DeleteRandomUserUseCase.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 27/6/25.
//

protocol DeleteRandomUserUseCase {
    func execute(byEmail email: String) throws
}

final class DeleteRandomUserUseCaseImpl: DeleteRandomUserUseCase {
    private let repository: RandomUserRepository

    init(repository: RandomUserRepository) {
        self.repository = repository
    }

    func execute(byEmail email: String) throws {
        try repository.deleteUser(byEmail: email)
    }
}
