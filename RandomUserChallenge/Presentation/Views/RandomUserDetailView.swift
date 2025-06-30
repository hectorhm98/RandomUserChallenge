//
//  RandomUserDetailView.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 28/6/25.
//

import SwiftUI

struct RandomUserDetailView: View {
    let user: RandomUser
    let onDelete: () -> Void
    
    @State private var showDeleteAlert = false
    
    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: URL(string: user.picture.large)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure(_):
                    Image(systemName: "person.crop.circle.badge.exclamationmark")
                case .empty:
                    ProgressView()
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            
            Text("\(user.name) \(user.surname)")
                .font(.title).bold()
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    DetailRow(label: "Email", value: user.email, icon: "envelope")
                    DetailRow(label: "Phone", value: user.phone, icon: "phone")
                    DetailRow(label: "Gender", value: user.gender.rawValue.capitalized, icon: "person")
                    DetailRow(label: "Location", value: "\(user.location.street), \(user.location.city), \(user.location.state)", icon: "mappin.and.ellipse")
                    DetailRow(label: "Registered", value: user.registered.formatted(), icon: "calendar")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 16)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("User Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role: .destructive, action: {
                    showDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                        .imageScale(.medium)
                }
            }
        }
        .alert("Are you sure you want to delete this user?", isPresented: $showDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        onDelete()
                    }
                    Button("Cancel", role: .cancel) {}
                }
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
            }
        }
    }
}


#Preview {
    RandomUserDetailView(user: dummyUsers.first!, onDelete: {})
}
