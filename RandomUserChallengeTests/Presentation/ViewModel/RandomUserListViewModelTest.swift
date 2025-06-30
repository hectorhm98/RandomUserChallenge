//
//  RandomUserListViewModelTest.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 30/6/25.
//

import XCTest

@testable import RandomUserChallenge

@MainActor
final class RandomUserListViewModelTest: XCTestCase {
    var mockRepo: MockRandomUserRepository!
    var viewModel: RandomUserListViewModel!

    override func setUp() {
        super.setUp()
        mockRepo = MockRandomUserRepository()
        viewModel = RandomUserListViewModel(
            getUsersUseCase: GetRandomUsersUseCaseImpl(repository: mockRepo),
            filterUsersUseCase: FilterRandomUsersUseCaseImpl(
                repository: mockRepo
            ),
            loadNewUsersForQueryUseCase: LoadNewUsersForQueryUseCaseImpl(
                repository: mockRepo
            ),
            deleteUserUseCase: DeleteRandomUserUseCaseImpl(repository: mockRepo)
        )
    }

    override func tearDown() {
        mockRepo = nil
        viewModel = nil
    }

    // MARK: - Load users tests
    func test_loadUsers_shouldFetchUsersAndUpdateViewModel() async {
        mockRepo.fetchUsersResult = dummyUsers

        await viewModel.loadUsers()

        XCTAssertEqual(viewModel.users.count, 2)
        XCTAssertEqual(viewModel.users.first?.email, "john.doe@example.com")
        XCTAssertTrue(mockRepo.fetchUsersCalled)
    }

    func test_loadUsers_shouldLoadMoreUsersWhenHasFilter() async {
        mockRepo.fetchUsersResult = dummyUsers
        mockRepo.fetchFilterUsersResult = [
            dummyUsers.last!,
            RandomUser(
                name: "Johana",
                surname: "Newone",
                email: "johana.newone@example.com",
                picture: Picture(
                    large: "large",
                    medium: "medium",
                    thumbnail: "thumbnail"
                ),
                phone: "123456789",
                gender: Gender.female,
                location: Location(
                    street: "8 Sesamo Street",
                    city: "New City",
                    state: "New State"
                ),
                registered: Date()
            ),
        ]
        viewModel.currentQuery = "johana"

        await viewModel.loadUsers()

        XCTAssertEqual(viewModel.users.count, 2)
        XCTAssertEqual(viewModel.users.first?.surname, "Doe")
        XCTAssertEqual(viewModel.users.last?.surname, "Newone")
        XCTAssertFalse(mockRepo.fetchUsersCalled)
        XCTAssertTrue(mockRepo.fetchNewUsersCalled)
    }

    func test_loadUsers_shouldNotLoadUsersWhenIsAlreadyLoading() async {
        mockRepo.fetchUsersResult = dummyUsers
        viewModel.isLoading = true

        await viewModel.loadUsers()

        XCTAssertEqual(viewModel.users.count, 0)
        XCTAssertFalse(mockRepo.fetchUsersCalled)
        XCTAssertFalse(mockRepo.fetchNewUsersCalled)
    }

    // MARK: - Filter users tests
    func test_applyfilter_shouldReturnFilteredUsers() {
        mockRepo.fetchUsersResult = dummyUsers
        mockRepo.fetchFilterUsersResult = [dummyUsers.last!]
        viewModel.currentQuery = "johana"

        viewModel.applyFilter()

        XCTAssertEqual(viewModel.users.count, 1)
        XCTAssertEqual(viewModel.users.first?.email, "johana.doe@example.com")
        XCTAssertTrue(mockRepo.fetchFilterUsersCalled)
    }

    func test_clearFilter_shouldReturnAllUsersAndClearCurrentQuery() async {
        mockRepo.fetchUsersResult = dummyUsers
        mockRepo.fetchFilterUsersResult = [dummyUsers.last!]
        viewModel.currentQuery = "johana"

        await viewModel.clearFilter()

        XCTAssertEqual(viewModel.users.count, 2)
        XCTAssertEqual(viewModel.users.first?.email, "john.doe@example.com")
        XCTAssertTrue(mockRepo.fetchUsersCalled)
        XCTAssertEqual(viewModel.currentQuery, "")
    }

    // MARK: - Delete users test
    func test_deleteUser_shouldDeleteUser() {
        viewModel.users = dummyUsers

        viewModel.deleteUser(email: "john.doe@example.com")

        XCTAssertEqual(viewModel.users.count, 1)
        XCTAssertEqual(viewModel.users.first?.email, "johana.doe@example.com")
        XCTAssertTrue(mockRepo.deleteUserByEmailCalled)
    }

    func test_selectUser_shouldSelectTheUser() {
        viewModel.users = dummyUsers

        viewModel.selectUser(user: viewModel.users.first!)

        XCTAssertEqual(viewModel.users.count, 2)
        XCTAssertEqual(viewModel.selectedUser, dummyUsers.first)
    }

    // MARK: - Error control behaviour
    func test_errors_shouldUpdateErrorMessageWhenErrorIsThrown() async {
        let mockRepoWithError = MockRandomUserRepositoryWithErrors()
        let viewModelError = RandomUserListViewModel(
            getUsersUseCase: GetRandomUsersUseCaseImpl(
                repository: mockRepoWithError
            ),
            filterUsersUseCase: FilterRandomUsersUseCaseImpl(
                repository: mockRepoWithError
            ),
            loadNewUsersForQueryUseCase: LoadNewUsersForQueryUseCaseImpl(
                repository: mockRepoWithError
            ),
            deleteUserUseCase: DeleteRandomUserUseCaseImpl(
                repository: mockRepoWithError
            )
        )

        await viewModelError.loadUsers()
        XCTAssertEqual(
            viewModelError.errorType,
            .fetch("Error loading users: \(MockError.fetchFailed.localizedDescription)")
        )

        viewModelError.deleteUser(email: "someUser", )
        XCTAssertEqual(
            viewModelError.errorType,
            .delete("Error deleting user: \(MockError.deleteUser.localizedDescription)")
        )

        viewModelError.applyFilter()
        XCTAssertEqual(
            viewModelError.errorType,
            .filter("Error filtering users: \(MockError.fetchFilteredUsers.localizedDescription)")
        )
        
        viewModelError.currentQuery = "someQuery"
        await viewModelError.loadUsers()
        XCTAssertEqual(
            viewModelError.errorType,
            .fetch("Error loading users: \(MockError.fetchNewUsers.localizedDescription)")
        )

    }

}
