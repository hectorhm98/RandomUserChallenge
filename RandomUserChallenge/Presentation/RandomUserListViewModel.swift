//
//  RandomUserListViewModel.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 27/6/25.
//
import Foundation

@MainActor
final class RandomUserListViewModel: ObservableObject {
    @Published var users: [RandomUser] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var currentQuery: String = ""
    
    private let getUsersUseCase: GetRandomUsersUseCase
    private let filterUsersUseCase: FilterRandomUsersUseCase
    private let loadNewUsersForQueryUseCase: LoadNewUsersForQueryUseCase
    private let deleteUserUseCase: DeleteRandomUserUseCase
    
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
    }
    
    //MARK: - Load users functions
    func loadUsers(batchSize: Int = 30) async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        do {
            let fetchUsers = currentQuery.isEmpty
                ? try await loadAllUsers(batchSize: batchSize)
                : try await loadFilteredUsers(batchSize: batchSize)
            users.append(contentsOf: fetchUsers)
        } catch {
            errorMessage = "Error loading users: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    private func loadAllUsers(batchSize: Int) async throws -> [RandomUser] {
        return try await getUsersUseCase.execute(offset: users.count, batchSize: batchSize)
    }

    private func loadFilteredUsers(batchSize: Int) async throws -> [RandomUser] {
        return try await loadNewUsersForQueryUseCase.execute(currentQuery: currentQuery, batchSize: batchSize)
    }
    
    //MARK: - Filter function
    func applyFilter(query: String) {
        currentQuery = query
        errorMessage = nil
        Task {
            do {
                let filtered = try filterUsersUseCase.execute(query: query)
                self.users = filtered
            } catch {
                errorMessage = "Error filtering users: \(error.localizedDescription)"
            }
        }
    }
    
    func clearFilter() {
        currentQuery = ""
        self.users = []
        Task {
            await loadUsers()
        }
    }
    
    func deleteUser(email: String) {
        Task {
            do {
                try deleteUserUseCase.execute(byEmail: email)
                self.users.removeAll { $0.email == email }
            } catch {
                errorMessage = "Error deleting user: \(error.localizedDescription)"
            }
        }
    }
}
