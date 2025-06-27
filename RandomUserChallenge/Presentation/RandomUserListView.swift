//
//  RandomUserListView.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 25/6/25.
//

import SwiftUI

struct RandomUserListView: View {
    @StateObject var viewModel: RandomUserListViewModel
    
    var body: some View {
            List {
                ForEach(viewModel.users) { user in
                    RandomUserCellView(
                        user: user,
                        isLast: user == viewModel.users.last,
                        onAppear: { Task { await viewModel.loadUsers() } },
                        onTap: { /*TODO navigation */ }
                    )
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .onAppear {
                Task { await viewModel.loadUsers() }
            }
        }
}

struct RandomUserCellView: View {
    let user: RandomUser
    let isLast: Bool
    let onAppear: () -> Void
    let onTap: () -> Void
    
    var body: some View {
        Text(user.email)
            .onTapGesture { onTap() }
            .onAppear {
                if isLast {
                    onAppear()
                }
            }
    }
}


#Preview {
    RandomUserListView(viewModel: .preview)
}
