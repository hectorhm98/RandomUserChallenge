//
//  CoreDataStack.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 26/6/25.
//
import CoreData

final class CoreDataStack {
    
    static let shared = CoreDataStack()
    private init() {}
    
    //MARK: - Persistent container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RandomUserStorage")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    // MARK: - Contexts
    var mainContext: NSManagedObjectContext {
            persistentContainer.viewContext
        }
    
    func newBackgroundContext() -> NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
}
