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

    var displayableErrorMessage: String? {
        switch viewModel.errorType {
        case .fetch(let message), .filter(let message):
            return message
        default:
            return nil
        }
    }

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                List {
                    if let message = displayableErrorMessage {
                        Text(message)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                        Button("Refresh") {
                            Task { await viewModel.loadUsers() }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    } else {
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
                        ) {
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
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .center
                                    )
                                    .padding()
                                    .id(UUID())  //Needs a new id to show correclty the loading icon of the ProgressView in the List
                            }
                            if !viewModel.isLoading {
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
                }
                .searchable(
                    text: $viewModel.currentQuery,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search by name, surename or email"
                )
                .onChange(of: viewModel.currentQuery) {
                    if viewModel.currentQuery.isEmpty {
                        Task {
                            await viewModel.clearFilter()
                        }
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
                .safeAreaInset(edge: .bottom) {
                    if case let .delete(message) = viewModel.errorType {
                        Text(message)
                            .padding(.top)
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.75))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    withAnimation {
                                        viewModel.errorType = nil
                                    }
                                }
                            }
                    }
                }
            }
        }
    }
}

#Preview {
    RandomUserListView(viewModel: .preview)
}
