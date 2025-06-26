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
            index: Int(index),
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
    func update(from model: RandomUser, deleted: Bool = false) {
        self.name = model.name
        self.surname = model.surname
        self.email = model.email
        self.pictureLarge = model.picture.large
        self.pictureMedium = model.picture.medium
        self.pictureThumbnail = model.picture.thumbnail
        self.phone = model.phone
        self.gender = model.gender.rawValue
        self.locationStreet = model.location.street
        self.locationCity = model.location.city
        self.locationState = model.location.state
        self.registered = model.registered
        self.index = Int64(model.index)
        self.deleted = deleted
    }
}


