//
//  RandomUserRepository.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 26/6/25.
//


protocol RandomUserRepository {
    func fetchUsers(page: Int, pageSize: Int) async throws -> [RandomUser]
}
