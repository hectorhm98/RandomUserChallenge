//
//  RandomUserDTO.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 25/6/25.
//
import Foundation

struct RandomUserDTO: Codable {
    let name: NameDTO
    let surname: String
    let email: String
    let picture: PictureDTO
    let phone: String
    let gender: String
    let location: LocationDTO
    let registered: Date
}
