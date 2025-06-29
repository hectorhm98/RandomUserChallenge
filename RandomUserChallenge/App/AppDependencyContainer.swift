//
//  AppDependencyContainer.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 28/6/25.
//


final class AppDependencyContainer {
    let userRepository: RandomUserRepository
    let getUsersUseCase: GetRandomUsersUseCase
    let deleteUserUseCase: DeleteRandomUserUseCase
    let filterRandomUserUseCase: FilterRandomUsersUseCase
    let loadNewUsersForQueryUseCase: LoadNewUsersForQueryUseCase
    let apiClient: RandomUserAPIClient
    let localStorage: RandomUserStorageQueryProtocol

    init(
            apiClient: RandomUserAPIClient,
            localStorage: RandomUserStorageQueryProtocol
    ) {
        self.apiClient = apiClient
        self.localStorage = localStorage
        self.userRepository = RandomUserRepositoryImpl(api: apiClient, localStorage: localStorage)
        
        self.getUsersUseCase = GetRandomUsersUseCaseImpl(repository: userRepository)
        self.deleteUserUseCase = DeleteRandomUserUseCaseImpl(repository: userRepository)
        self.filterRandomUserUseCase = FilterRandomUsersUseCaseImpl(repository: userRepository)
        self.loadNewUsersForQueryUseCase = LoadNewUsersForQueryUseCaseImpl(repository: userRepository)
    }

    @MainActor func makeRandomUserListViewModel() -> RandomUserListViewModel {
        return RandomUserListViewModel(getUsersUseCase: getUsersUseCase, filterUsersUseCase: filterRandomUserUseCase, loadNewUsersForQueryUseCase: loadNewUsersForQueryUseCase, deleteUserUseCase: deleteUserUseCase)
    }
}


//MARK: - Extension to make different environment containers
extension AppDependencyContainer {
    //In this case there is only production
    static let production = AppDependencyContainer(
        apiClient: RandomUserAPIClientImpl(),
        localStorage: RandomUserStorageQuery(context: CoreDataStack.shared.newBackgroundContext())
    )
}

