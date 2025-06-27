//
//  CoreDataTestHelper.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 27/6/25.
//

import CoreData
import RandomUserChallenge

func makeInMemoryManagedObjectContext() -> NSManagedObjectContext {
    let container = NSPersistentContainer(name: "RandomUserStorage")
    let description = NSPersistentStoreDescription()
    description.url = URL(fileURLWithPath: "/dev/null")
    container.persistentStoreDescriptions = [description]

    container.loadPersistentStores { _, error in
        if let error = error {
            fatalError("Error loading test store: \(error)")
        }
    }

    return container.viewContext
}


extension RandomUserEntity {
    internal static func create(
        in context: NSManagedObjectContext,
        email: String = "john.doe@example.com",
        name: String = "John",
        surname: String = "Doe",
        phone: String = "123456789",
        gender: String = "male",
        index: Int64 = 0,
        deleted: Bool = false,
        pictureLarge: String = "large",
        pictureMedium: String = "medium",
        pictureThumbnail: String = "thumb",
        registeredDate: Date = Date(),
        city: String = "City",
        state: String = "State",
        streetName: String = "123 Street",
    ) -> RandomUserEntity {
        let entity = RandomUserEntity(context: context)
        entity.email = email
        entity.name = name
        entity.surname = surname
        entity.phone = phone
        entity.gender = gender
        entity.index = index
        entity.deletedUser = deleted
        entity.pictureLarge = pictureLarge
        entity.pictureMedium = pictureMedium
        entity.pictureThumbnail = pictureThumbnail
        entity.registered = registeredDate
        entity.locationCity = city
        entity.locationState = state
        entity.locationStreet = streetName
        return entity
    }
}
