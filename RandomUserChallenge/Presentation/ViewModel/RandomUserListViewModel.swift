import Combine
//
//  RandomUserListViewModel.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 27/6/25.
//
import Foundation

@MainActor
final class RandomUserListViewModel: ObservableObject {
    //MARK: - Published variables
    @Published var users: [RandomUser] = []
    @Published var isLoading: Bool = false
    @Published var errorType: ErrorType? = nil
    @Published var currentQuery: String = ""
    @Published var selectedUser: RandomUser? = nil
    @Published var isScrolling: Bool = false

    //MARK: - Use Cases constants
    private let getUsersUseCase: GetRandomUsersUseCase
    private let filterUsersUseCase: FilterRandomUsersUseCase
    private let loadNewUsersForQueryUseCase: LoadNewUsersForQueryUseCase
    private let deleteUserUseCase: DeleteRandomUserUseCase

    private var queryCancellable = Set<AnyCancellable>()
    private var scrollCancellable = Set<AnyCancellable>()

    init(
        getUsersUseCase: GetRandomUsersUseCase,
        filterUsersUseCase: FilterRandomUsersUseCase,
        loadNewUsersForQueryUseCase: LoadNewUsersForQueryUseCase,
        deleteUserUseCase: DeleteRandomUserUseCase
    ) {
        self.getUsersUseCase = getUsersUseCase
        self.filterUsersUseCase = filterUsersUseCase
        self.loadNewUsersForQueryUseCase = loadNewUsersForQueryUseCase
        self.deleteUserUseCase = deleteUserUseCase

        $currentQuery  //This will help apply filters when the user stops writting even without submitting it -> For UX propouses
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newValue in
                if !newValue.isEmpty {
                    self?.applyFilter()
                }
            }
            .store(in: &queryCancellable)
        $isScrolling  //This will help to know when the view will stop scrolling
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.isScrolling = false
            }
            .store(in: &scrollCancellable)
    }

    //MARK: - Load users functions
    func loadUsers(batchSize: Int = 30) async {
        guard !isLoading else { return }
        isLoading = true
        errorType = nil
        do {
            if currentQuery.isEmpty {
                users.append(
                    contentsOf: try await loadAllUsers(batchSize: batchSize)
                )
            } else {
                users = try await loadFilteredUsers(batchSize: batchSize)
            }
        } catch {
            errorType = .fetch("Error loading users: \(error.localizedDescription)")
        }
        isLoading = false
    }

    private func loadAllUsers(batchSize: Int) async throws -> [RandomUser] {
        return try await getUsersUseCase.execute(
            offset: users.count,
            batchSize: batchSize
        )
    }

    private func loadFilteredUsers(batchSize: Int) async throws -> [RandomUser]
    {
        return try await loadNewUsersForQueryUseCase.execute(
            currentQuery: currentQuery,
            batchSize: batchSize
        )
    }

    //MARK: - Filter function
    func applyFilter() {
        errorType = nil
        do {
            let filtered = try filterUsersUseCase.execute(
                query: currentQuery
            )
            self.users = filtered
        } catch {
            errorType = .filter("Error filtering users: \(error.localizedDescription)")
        }
    }

    func clearFilter() async {
        currentQuery = ""
        self.users = []
        await loadUsers()
    }

    //MARK: - Delete function
    func deleteUser(email: String) {
        errorType = nil
        do {
            try deleteUserUseCase.execute(byEmail: email)
            self.users.removeAll { $0.email == email }
            self.selectedUser = nil
        } catch {
            errorType = .delete("Error deleting user: \(error.localizedDescription)")
        }
    }

    func selectUser(user: RandomUser) {
        selectedUser = user
    }
}
