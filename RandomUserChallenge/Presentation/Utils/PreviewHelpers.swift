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
        try await Task.sleep(for: .seconds(2))
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

let dummyUsers: [RandomUser] = [
    RandomUser(name: "John", surname: "Doe", email: "john.doe@example.com", picture: Picture(large: "https://randomuser.me/api/portraits/men/69.jpg", medium: "https://randomuser.me/api/portraits/med/men/69.jpg", thumbnail: "https://randomuser.me/api/portraits/thumb/men/69.jpg"), phone: "600111222", gender: Gender.male, location: Location(street: "221B Baker Street", city: "Oklahoma", state: "California"), registered: Date()),
    RandomUser(name: "Johana", surname: "Doe", email: "johana.doe@example.com", picture: Picture(large: "https://randomuser.me/api/portraits/women/86.jpg", medium: "https://randomuser.me/api/portraits/med/women/86.jpg", thumbnail: "https://randomuser.me/api/portraits/thumb/women/86.jpg"), phone: "600333444", gender: Gender.female, location: Location(street: "221B Baker Street", city: "Oklahoma", state: "California"), registered: Date()),
]

// MARK: - Preview configuration for VM
#if DEBUG
extension RandomUserListViewModel {
    static var preview: RandomUserListViewModel {
        let vm = RandomUserListViewModel(
            getUsersUseCase: MockGetUsersUseCase(users: dummyUsers),
            filterUsersUseCase: MockFilterUsersUseCase(filtered: dummyUsers),
            loadNewUsersForQueryUseCase: MockLoadNewUsersForQueryUseCase(users: dummyUsers),
            deleteUserUseCase: MockDeleteUserUseCase()
        )
        return vm
    }
}
#endif
