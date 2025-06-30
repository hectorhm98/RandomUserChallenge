//
//  ErrorType.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 30/6/25.
//

enum ErrorType: Equatable {
    case fetch(String)
    case filter(String)
    case delete(String)
}
