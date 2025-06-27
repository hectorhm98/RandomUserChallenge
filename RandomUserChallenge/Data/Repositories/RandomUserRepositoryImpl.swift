//
//  RandomUserRepositoryImpl.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 26/6/25.
//

final class RandomUserRepositoryImpl: RandomUserRepository {
    private let api: RandomUserAPIClient
    private let localStorage: RandomUserStorageQueryProtocol
    private let pageSize = 20

    init(api: RandomUserAPIClient, localStorage: RandomUserStorageQueryProtocol) {
        self.api = api
        self.localStorage = localStorage
    }

    func fetchUsers(at: Int, batchSize: Int) async throws -> [RandomUser] {
        let localUsers = try localStorage.fetchUsers(offset: at, limit: batchSize)
        var remaining = batchSize - localUsers.count
        
        if (remaining == 0) {
            return localUsers.map { $0.toDomain() }
        }
        
        let maxAttempts = 10
        var attempts = 0
        
        while remaining > 0 && attempts < maxAttempts { // Added a maxAttempts to avoid infinite bucle if API just returns repeated users.
            let fetchedDTOs = try await api.fetchRandomUsers(resultSize: remaining)
            let insertedCount = try fetchedDTOs.reduce(0) { count, dto in
                try localStorage.saveIfNotExists(dto) ? count + 1 : count
            }
            remaining -= insertedCount
            attempts += 1
        }
        //I opted with this approach to keep the flow DTO (API) -> CoreData (Local) -> Domain, just to keep consistency of data. Since the batchSize should not be extremetly big, the performance of a second read will be marginal.
        let finalUsers = try localStorage.fetchUsers(offset: at, limit: batchSize)
        return finalUsers.map { $0.toDomain() }
    }
    
    func deleteUser(byEmail email: String) throws {
        try localStorage.softDeleteUser(byEmail: email)
    }
}
