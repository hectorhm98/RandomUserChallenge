//
//  RandomUserRepository.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 26/6/25.
//


protocol RandomUserRepository {
    func fetchUsers(at: Int, batchSize: Int) async throws -> [RandomUser]
    func deleteUser(byEmail email: String) throws
}
