//
//  RandomUserEntity+Mapper.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 26/6/25.
//

import CoreData
import Foundation

extension RandomUserEntity {
    func toDomain() -> RandomUser { //We force unwrap because the attributes of a RandomUserEntity will never be nil,
        RandomUser(                 //but it cames as Optional
            name: name!,
            surname: surname!,
            email: email!,
            picture: Picture(
                large: pictureLarge!,
                medium: pictureMedium!,
                thumbnail: pictureThumbnail!
            ),
            phone: phone!,
            gender: Gender(rawValue: gender!) ?? .unknown,
            location: Location(
                street: locationStreet!,
                city: locationCity!,
                state: locationState!
            ),
            registered: registered!
        )
    }
}


extension RandomUserEntity {
    func update(from dto: RandomUserDTO, index: Int64, deleted: Bool = false) {
        self.name = dto.name.first
        self.surname = dto.name.last
        self.email = dto.email
        self.pictureLarge = dto.picture.large
        self.pictureMedium = dto.picture.medium
        self.pictureThumbnail = dto.picture.thumbnail
        self.phone = dto.phone
        self.gender = dto.gender
        self.locationStreet = "\(dto.location.street.number) \(dto.location.street.name)"
        self.locationCity = dto.location.city
        self.locationState = dto.location.state
        self.registered = dto.registered
        self.index = index
        self.deletedUser = deleted
    }
}


