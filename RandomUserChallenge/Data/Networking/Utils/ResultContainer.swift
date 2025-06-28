//
//  ResultContainer.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 28/6/25.
//

struct ResultsContainer<T: Codable>: Codable {
    let results: [T]
}

