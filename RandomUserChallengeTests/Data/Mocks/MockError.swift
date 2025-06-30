//
//  MockError.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 30/6/25.
//
import Foundation

enum MockError: LocalizedError {
    case fetchFailed
    case deleteUser
    case fetchFilteredUsers
    case fetchNewUsers

    var errorDescription: String? {
        switch self {
        case .fetchFailed:
            return "Failed to fetch users for testing."
        case .deleteUser:
            return "Failed to delete user for testing."
        case .fetchFilteredUsers:
            return "Failed to fetch filtered users for testing."
        case .fetchNewUsers:
            return "Failed to fetch new users for testing."
        }
    }
}
