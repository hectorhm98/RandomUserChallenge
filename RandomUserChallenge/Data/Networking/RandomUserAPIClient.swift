//
//  RandomUserAPIClient.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 25/6/25.
//
import Foundation

protocol RandomUserAPIClient {
    func fetchRandomUsers(resultSize: Int) async throws -> [RandomUserDTO]
}

class RandomUserAPIClientImpl: RandomUserAPIClient {
    public init() {
        
    }
    
    func fetchRandomUsers(resultSize: Int) async throws -> [RandomUserDTO] {
        guard let url = URL(string: "https://api.randomuser.me/?results=\(resultSize)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let container = try JSONDecoder.withISO8601Milliseconds().decode(ResultsContainer<RandomUserDTO>.self, from: data)
        return container.results
    }
}
