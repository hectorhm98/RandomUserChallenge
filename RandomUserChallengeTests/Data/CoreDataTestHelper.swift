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
