//
//  PreviewHelpers.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 27/6/25.
//

import SwiftUI

// MARK: - Mocks for Preview

struct MockGetUsersUseCase: GetRandomUsersUseCase {
    let users: [RandomUser]
    func execute(offset: Int, batchSize: Int) async throws -> [RandomUser] {
        guard offset == 0 else { return [] }
        return users
    }
}

struct MockFilterUsersUseCase: FilterRandomUsersUseCase {
    let filtered: [RandomUser]
    func execute(query: String) throws -> [RandomUser] {
        return filtered
    }
}

struct MockLoadNewUsersForQueryUseCase: LoadNewUsersForQueryUseCase {
    let users: [RandomUser]
    func execute(currentQuery: String, batchSize: Int) async throws -> [RandomUser] {
        return users
    }
}

struct MockDeleteUserUseCase: DeleteRandomUserUseCase {
    func execute(byEmail email: String) throws {}
}

// MARK: - Preview configuration for VM
#if DEBUG
extension RandomUserListViewModel {
    static var preview: RandomUserListViewModel {
        let dummyUsers: [RandomUser] = [
            RandomUser(name: "John", surname: "Doe", email: "john.doe@example.com", picture: Picture(large: "", medium: "", thumbnail: ""), phone: "600111222", gender: Gender.male, location: Location(street: "221B Baker Street", city: "Oklahoma", state: "California"), registered: Date()),
            RandomUser(name: "Johana", surname: "Doe", email: "joahn.doe@example.com", picture: Picture(large: "", medium: "", thumbnail: ""), phone: "600333444", gender: Gender.female, location: Location(street: "221B Baker Street", city: "Oklahoma", state: "California"), registered: Date()),
        ]
        let vm = RandomUserListViewModel(
            getUsersUseCase: MockGetUsersUseCase(users: dummyUsers),
            filterUsersUseCase: MockFilterUsersUseCase(filtered: dummyUsers),
            loadNewUsersForQueryUseCase: MockLoadNewUsersForQueryUseCase(users: dummyUsers),
            deleteUserUseCase: MockDeleteUserUseCase()
        )
        vm.users = dummyUsers
        return vm
    }
}
#endif
