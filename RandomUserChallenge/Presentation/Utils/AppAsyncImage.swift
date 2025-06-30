//
//  AppAsyncImage.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 30/6/25.
//

import SwiftUI

struct AppAsyncImage<Placeholder: View>: View {
    let url: URL?
    let placeholder: () -> Placeholder
    let fallbackName: String

    var body: some View {
        #if DEBUG
        AsyncImageMock(imageName: fallbackName)
        #else
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                placeholder()
            case .success(let image):
                image.resizable().aspectRatio(contentMode: .fill)
            case .failure:
                placeholder()
            @unknown default:
                placeholder()
            }
        }
        #endif
    }
}


struct AsyncImageMock: View {
    let imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipped()
    }
}
