//
//  RandomUser.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 25/6/25.
//
import Foundation

enum Gender: String {
    case male = "male"
    case female = "female"
    case unknown = "unknown"
}

struct RandomUser {
    let name: String
    let surname: String
    let email: String
    let picture: Picture
    let phone: String
    let gender: Gender
    let location: Location
    let registered: Date
}
