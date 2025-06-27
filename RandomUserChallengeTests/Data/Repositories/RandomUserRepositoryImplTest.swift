//
//  RandomUserRepositoryImplTest.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 27/6/25.
//
import CoreData
import XCTest
@testable import RandomUserChallenge

final class RandomUserRepositoryTests: XCTestCase {
    var storage: RandomUserStorageQuery!
    var context: NSManagedObjectContext!
    let apiUsers: [RandomUserDTO] = [RandomUserDTO(name: NameDTO(title: "Mr", first: "John", last: "Doe"), email: "john.doe@example.com", picture: PictureDTO(large: "pictureLarge", medium: "pictureMedium", thumbnail: "pictureThumbnail"), phone: "1234567890", gender: "male", location: LocationDTO(street: StreetDTO(number: 221, name: "Backer Street"), city: "United States", state: "Arizona"), registered: Date())]

    override func setUp() {
        super.setUp()
        context = makeInMemoryManagedObjectContext()
        storage = RandomUserStorageQuery(context: context)
    }

    override func tearDown() {
        storage = nil
        context = nil
        super.tearDown()
    }

    //This test will make sure to call API if there is no local data persisted
    func test_fetchUsers_callsAPIAndSavesIfNoLocalData() async throws {
        let apiMock = RandomUserAPIClientMock()
        apiMock.usersToReturn = apiUsers

        let repo = RandomUserRepositoryImpl(api: apiMock, localStorage: storage)
        
        let users = try await repo.fetchUsers(at: 0, batchSize: 1)

        XCTAssertEqual(apiMock.fetchCalled, 1)
        XCTAssertEqual(try storage.getNextIndex(), 1)
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first?.email, "john.doe@example.com")
    }
    
    //This test will guarantee that no API is called if the data is persisted
    func test_fetchUsers_usesLocalDataIfAvailable() async throws {
        _ = RandomUserEntity.create(in: context, email: "john.doe@example.com", index: 0)
        try context.save()
        
        let apiMock = RandomUserAPIClientMock()
        let repo = RandomUserRepositoryImpl(api: apiMock, localStorage: storage)
        
        let users = try await repo.fetchUsers(at: 0, batchSize: 1)
        
        XCTAssertEqual(apiMock.fetchCalled, 0)
        XCTAssertEqual(users.count, 1)
        XCTAssertEqual(users.first?.email, "john.doe@example.com")
    }
    
    //This test asserts that deleted users are not being retrieved when fetchUsers
    func test_fetchUsers_ignoresDeletedUsers() async throws {
        _ = RandomUserEntity.create(in: context, email: "john.doe.first@example.com", index: 0)
        _ = RandomUserEntity.create(in: context, email: "alternative.john.doe@example.com", index: 1, deleted: true)
        _ = RandomUserEntity.create(in: context, email: "another.john.doe@example.com", index: 2,)
        try context.save()
        
        let apiMock = RandomUserAPIClientMock()
        let repo = RandomUserRepositoryImpl(api: apiMock, localStorage: storage)
        apiMock.usersToReturn = apiUsers
        
        let users = try await repo.fetchUsers(at: 0, batchSize: 3)
        
        XCTAssertEqual(apiMock.fetchCalled, 1)
        XCTAssertEqual(users.count, 3)
        XCTAssertEqual(try storage.getNextIndex(), 4)
        XCTAssertEqual(users.last?.email, "john.doe@example.com")
    }
    
    //This test will assert that no repeated RandomUser is stored. Also the retryLimit if API returns always the same
    func test_fetchUsers_respectsRetryLimitOnDuplicates() async throws {
        _ = RandomUserEntity.create(in: context, email: "john.doe.first@example.com", index: 0)
        try context.save()
        
        let apiMock = RandomUserAPIClientMock()
        let repo = RandomUserRepositoryImpl(api: apiMock, localStorage: storage)
        apiMock.usersToReturn = apiUsers
        
        let users = try await repo.fetchUsers(at: 0, batchSize: 3)
        
        XCTAssertEqual(apiMock.fetchCalled, 10)
        XCTAssertEqual(users.count, 2)
        XCTAssertEqual(try storage.getNextIndex(), 2)
        XCTAssertEqual(users.last?.email, "john.doe@example.com")
    }
}
