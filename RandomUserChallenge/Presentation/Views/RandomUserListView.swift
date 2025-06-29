//
//  RandomUserListView.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 25/6/25.
//

import SwiftUI

struct RandomUserListView: View {
    @StateObject var viewModel: RandomUserListViewModel
    @State private var showBackTopButton: Bool = false

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                List {
                    Section(
                        header:
                            Text("User list")
                            .id("top")
                            .onAppear {
                                showBackTopButton = false
                            }
                            .onDisappear {
                                showBackTopButton = true
                            }
                    )
                    {
                        ForEach(viewModel.users) { user in
                            RandomUserCellView(
                                user: user,
                                isLast: user == viewModel.users.last,
                                onAppear: {
                                    if viewModel.currentQuery.isEmpty {
                                        Task { await viewModel.loadUsers() }
                                    }
                                },
                                onTap: { viewModel.selectUser(user: user) }
                            )
                            .onAppear {
                                viewModel.isScrolling = true

                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.deleteUser(email: user.email)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                .id(UUID())  //Needs a new id to show correclty the loading icon of the ProgressView in the List
                        }
                        if !viewModel.isLoading
                        {
                            Button("Can't find the user? Load more") {
                                Task {
                                    await viewModel.loadUsers(batchSize: 60)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .multilineTextAlignment(.center)
                        }
                    }
                }
                .searchable(
                    text: $viewModel.currentQuery,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search by name, surename or email"
                )
                .onChange(of: viewModel.currentQuery) {
                    if viewModel.currentQuery.isEmpty {
                        viewModel.clearFilter()
                    }
                }
                .onSubmit(of: .search) {
                    viewModel.applyFilter()
                }
                .navigationTitle("Random Users")
                .onAppear {
                    if viewModel.users.isEmpty {
                        Task { await viewModel.loadUsers() }
                    }
                }
                .navigationDestination(item: $viewModel.selectedUser) {
                    selected in
                    RandomUserDetailView(
                        user: selected,
                        onDelete: {
                            viewModel.deleteUser(email: selected.email)
                        }
                    )
                }
                .background(Color(UIColor.systemGroupedBackground))
                .overlay(
                    Group {
                        if !viewModel.isScrolling && showBackTopButton {
                            Button(action: {
                                withAnimation {
                                    proxy.scrollTo("top", anchor: .top)
                                }
                            }) {
                                Image(systemName: "arrow.up")
                                    .padding()
                                    .background(.thinMaterial)
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                            }
                            .padding()
                            .transition(.opacity.combined(with: .scale))
                        }
                    },
                    alignment: .bottomTrailing
                )
                .animation(
                    .default,
                    value: viewModel.isScrolling
                )
            }
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
        .frame(maxWidth: .infinity, alignment: .leading)  //To expand the area for TapGesture
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
