//
//  MockRandomUserRepository.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 30/6/25.
//
@testable import RandomUserChallenge
import Foundation

final class MockRandomUserRepository: RandomUserRepository {
    var fetchUsersResult: [RandomUser] = []
    var fetchUsersCalled = false
    var fetchFilterUsersResult: [RandomUser] = []
    var fetchFilterUsersCalled = false
    var fetchNewUsersCalled = false
    var deleteUserByEmailCalled = false

    func fetchUsers(at offset: Int, batchSize: Int) async throws -> [RandomUser] {
        fetchUsersCalled = true
        return fetchUsersResult
    }

    func deleteUser(byEmail email: String) throws {
        deleteUserByEmailCalled = true
        fetchUsersResult.removeAll { $0.email == email }
    }
    
    func fetchFilteredUsers(by query: String) throws -> [RandomUser] {
        fetchFilterUsersCalled = true
        return fetchFilterUsersResult
    }
    
    func fetchNewUsers(batchSize: Int) async throws {
        fetchNewUsersCalled = true
    }
}

final class MockRandomUserRepositoryWithErrors: RandomUserRepository {

    func fetchUsers(at offset: Int, batchSize: Int) async throws -> [RandomUser] {
        throw MockError.fetchFailed
    }

    func deleteUser(byEmail email: String) throws {
        throw MockError.deleteUser
    }
    
    func fetchFilteredUsers(by query: String) throws -> [RandomUser] {
        throw MockError.fetchFilteredUsers
    }
    
    func fetchNewUsers(batchSize: Int) async throws {
        throw MockError.fetchNewUsers
    }
}

