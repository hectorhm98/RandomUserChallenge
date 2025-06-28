//
//  RandomUserDetailView.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 28/6/25.
//

import SwiftUI

struct RandomUserDetailView: View {
    let user: RandomUser
    
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
                .font(.title2).bold()
            
            Text(user.email)
                .foregroundStyle(.secondary)
            
            Text(user.phone)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .padding()
        .navigationTitle("User Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}
