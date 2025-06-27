//
//  RandomUserRepositoryImplTest.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 27/6/25.
//

import XCTest
@testable import RandomUserChallenge

final class RandomUserRepositoryTests: XCTestCase {

    func testFetchUsersCallsAPIAndSaves() async throws {
        let apiMock = RandomUserAPIClientMock()
        apiMock.usersToReturn = [RandomUserDTO(name: NameDTO(title: "Mr", first: "John", last: "Doe"), email: "jonh.doe@example.com", picture: PictureDTO(large: "pictureLarge", medium: "pictureMedium", thumbnail: "pictureThumbnail"), phone: "1234567890", gender: "male", location: LocationDTO(street: StreetDTO(number: 221, name: "Backer Street"), city: "United States", state: "Arizona"), registered: Date())]

        let contextMock = makeInMemoryManagedObjectContext()
        let storage = RandomUserStorageQuery(context: contextMock)

        let repo = RandomUserRepositoryImpl(api: apiMock, localStorage: storage)
        
        let users = try await repo.fetchUsers(at: 0, batchSize: 1)

        XCTAssertTrue(apiMock.fetchCalled)
        XCTAssertEqual(try storage.getNextIndex(), 1)
        XCTAssertEqual(users.count, 1)
    }
}
