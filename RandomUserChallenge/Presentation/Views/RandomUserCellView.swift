//
//  RandomUserCellView.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 30/6/25.
//

import SwiftUI

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
