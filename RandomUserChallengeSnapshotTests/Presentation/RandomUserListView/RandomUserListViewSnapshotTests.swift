//
//  RandomUserListViewSnapshotTests.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 30/6/25.
//

import SwiftUI
import SnapshotTesting
import Testing

@testable import RandomUserChallenge

@MainActor
struct RandomUserListViewSnapshotTests {
    init() async throws {

    }

    @Test func test_EmptyUserList() {
        let vm = RandomUserListViewModel.emptyState
        let view = RandomUserListView(viewModel: vm)
        assertAllSnapshots(of: view, named: "EmptyUserList")
    }

    @Test func test_UserListWithData() {
        let vm = RandomUserListViewModel.fullState
        let view = RandomUserListView(viewModel: vm)
        assertAllSnapshots(of: view, named: "FullUserList")
    }

    @Test func test_ErrorState() {
        let vm = RandomUserListViewModel.errorState
        let view = RandomUserListView(viewModel: vm)
        assertAllSnapshots(of: view, named: "ErrorState")
    }
    
    @Test func test_UserListWithFirstDeleted() {
        let vm = RandomUserListViewModel.fullState
        let view = RandomUserListView(viewModel: vm)
        
        vm.deleteUser(email: vm.users.first!.email)
        assertAllSnapshots(of: view, named: "FirstDeletedState")
    }
    
    @Test func test_DeletionErrorState() {
        let vm = RandomUserListViewModel.fullState
        let view = RandomUserListView(viewModel: vm)
        vm.errorType = .delete("Error on deletion")
        assertAllSnapshots(of: view, named: "DeletionErrorState")
    }
}
