//
//  RandomUserMapper.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 25/6/25.
//

// MARK: - This mapper will not be used for the project, but it's kept to show that it could be used if we removed local persistance
struct RandomUserMapper {
    static func map(from dto: RandomUserDTO) -> RandomUser {
        return RandomUser(
            name: dto.name.first,
            surname: dto.name.last,
            email: dto.email,
            picture: Picture(large: dto.picture.large, medium: dto.picture.medium, thumbnail: dto.picture.thumbnail),
            phone: dto.phone,
            gender: Gender(rawValue: dto.gender) ?? .unknown,
            location: Location(street: "\(dto.location.street.number) \(dto.location.street.name)", city: dto.location.city, state: dto.location.state),
            registered: dto.registered
        )
    }
}
