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
        NavigationStack {
            List {
                ForEach(viewModel.users) { user in
                    RandomUserCellView(
                        user: user,
                        isLast: user == viewModel.users.last,
                        onAppear: { Task { await viewModel.loadUsers() } },
                        onTap: { viewModel.selectUser(user: user) }
                    )
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.deleteUser(email: user.email)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(.vertical, 8)
            .navigationTitle("Random Users")
            .overlay {
                if viewModel.isLoading {
                    ZStack {
                        Color(UIColor.systemGroupedBackground)
                            .ignoresSafeArea()
                        ProgressView()
                    }
                }
            }
            .onAppear {
                if viewModel.users.isEmpty {
                    Task { await viewModel.loadUsers() }
                }
            }
            .navigationDestination(item: $viewModel.selectedUser) { selected in
                RandomUserDetailView(user: selected, onDelete: {
                    viewModel.deleteUser(email: selected.email)
                })
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}

struct RandomUserCellView: View {
    let user: RandomUser
    let isLast: Bool
    let onAppear: () -> Void
    let onTap: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            AsyncImage(url: URL(string: user.picture.thumbnail)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .shadow(radius: 4)
            .padding(.trailing, 16)
            VStack(alignment: .leading, spacing: 4) {
                Text("\(user.name) \(user.surname)")
                    .font(.headline)
            
                HStack(alignment: .center, spacing: 6) {
                    Image(systemName: "envelope")
                        .imageScale(.small)
                    Text(user.email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                HStack(alignment: .center, spacing: 6) {
                    Image(systemName: "phone")
                        .font(.subheadline)
                    Text(user.phone)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading) //To expand the area for TapGesture
        .contentShape(Rectangle())
        .padding(.vertical, 8)
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
