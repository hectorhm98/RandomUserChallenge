//
//  MockRandomUserListModelView.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 30/6/25.
//

import Foundation

@testable import RandomUserChallenge

extension RandomUserListViewModel {
    static var emptyState: RandomUserListViewModel {
        let vm = MockRandomUserListViewModel.base
        vm.users = []
        return vm
    }

    static var fullState: RandomUserListViewModel {
        let vm = MockRandomUserListViewModel.base
        vm.users = FakeRandomUserFactory.generate(count: 10)
        return vm
    }

    static var errorState: RandomUserListViewModel {
        let vm = MockRandomUserListViewModel.base
        vm.errorType = .fetch("Something went wrong!")
        return vm
    }
}

@MainActor
enum MockRandomUserListViewModel {
    static var base: RandomUserListViewModel {
        RandomUserListViewModel(
            getUsersUseCase: MockGetUsersUseCase(users: []),
            filterUsersUseCase: MockFilterUsersUseCase(filtered: []),
            loadNewUsersForQueryUseCase: MockLoadNewUsersForQueryUseCase(
                users: []),
            deleteUserUseCase: MockDeleteUserUseCase()
        )
    }
}

enum FakeRandomUserFactory {
    static func generate(count: Int) -> [RandomUser] {
        return (0..<count).map {
            RandomUser(
                name: "User \($0)",
                surname: "Surename \($0)",
                email: "user\($0)@test.com",
                picture: Picture(
                    large: "https://example.com/image\($0).jpg",
                    medium: "https://example.com/image\($0).jpg",
                    thumbnail: "https://example.com/image\($0).jpg"
                ),
                phone: "123456789\($0)",
                gender: Gender.male,
                location: Location(
                    street: "\($0) Street",
                    city: "Fake City",
                    state: "Fake State"
                ),
                registered: Date()
            )
        }
    }
}

