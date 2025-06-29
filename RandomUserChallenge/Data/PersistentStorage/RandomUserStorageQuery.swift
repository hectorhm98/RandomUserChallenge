//
//  RandomUserStorageQuery.swift
//  RandomUserChallenge
//
//  Created by Hector Hernandez Montilla on 26/6/25.
//
import CoreData

protocol RandomUserStorageQueryProtocol {
    func fetchUser(byEmail email: String) throws -> RandomUserEntity?
    func fetchUsers(offset: Int, limit: Int) throws -> [RandomUserEntity]
    func fetchUsers(by query: String) throws -> [RandomUserEntity]
    func saveIfNotExists(_ dto: RandomUserDTO) throws -> Bool
    func softDeleteUser(byEmail email: String) throws
    func getNextIndex() throws -> Int64
}

final class RandomUserStorageQuery: RandomUserStorageQueryProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    //MARK: - Fetch functions
    func fetchUser(byEmail email: String) throws -> RandomUserEntity? {
        let request: NSFetchRequest<RandomUserEntity> =
            RandomUserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email)
        var fetchResult: [RandomUserEntity] = []
        try context.performAndWait {
            fetchResult = try context.fetch(request)
        }
        return fetchResult.first
    }

    func fetchUsers(offset: Int, limit: Int) throws -> [RandomUserEntity] {
        let request: NSFetchRequest<RandomUserEntity> =
            RandomUserEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "deletedUser == %@",
            NSNumber(value: false)
        )
        request.sortDescriptors = [
            NSSortDescriptor(key: "index", ascending: true)
        ]
        request.fetchOffset = offset
        request.fetchLimit = limit
        var fetchResult: [RandomUserEntity] = []
        try context.performAndWait {
            fetchResult = try context.fetch(request)
        }
        return fetchResult
    }

    func fetchUsers(by query: String) throws -> [RandomUserEntity] {
        let request: NSFetchRequest<RandomUserEntity> =
            RandomUserEntity.fetchRequest()
        let queryPredicates = NSCompoundPredicate(
            orPredicateWithSubpredicates: [
                NSPredicate(format: "name CONTAINS[cd] %@", query),
                NSPredicate(format: "surname CONTAINS[cd] %@", query),
                NSPredicate(format: "email CONTAINS[cd] %@", query),
            ])
        let finalPredicate: NSCompoundPredicate =
            NSCompoundPredicate(andPredicateWithSubpredicates: [
                queryPredicates,
                NSPredicate(
                    format: "deletedUser == %@",
                    NSNumber(value: false)
                ),
            ])
        request.predicate = finalPredicate
        request.sortDescriptors = [
            NSSortDescriptor(key: "index", ascending: true)
        ]
        var fetchResult: [RandomUserEntity] = []
        try context.performAndWait {
            fetchResult = try context.fetch(request)
        }
        return fetchResult
    }

    //MARK: - Save function
    func saveIfNotExists(_ dto: RandomUserDTO) throws -> Bool {
        if (try fetchUser(byEmail: dto.email)) != nil {
            return false
        }
        let nextIndex = try getNextIndex()
        let entity = RandomUserEntity(context: context)
        entity.update(from: dto, index: nextIndex)
        try context.performAndWait {
            try context.save()
        }
        return true
    }

    //MARK: - Delete function
    func softDeleteUser(byEmail email: String) throws {
        guard let entity = try fetchUser(byEmail: email) else { return }
        entity.deletedUser = true
        try context.performAndWait {
            try context.save()
        }
    }

    func getNextIndex() throws -> Int64 {  //Use max on NSDictionary fetch instead of filter by index for performance/efficience reason
        let fetchRequest = NSFetchRequest<NSDictionary>(
            entityName: "RandomUserEntity"
        )
        fetchRequest.resultType = .dictionaryResultType

        let expression = NSExpression(
            forFunction: "max:",
            arguments: [NSExpression(forKeyPath: "index")]
        )
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "maxIndex"
        expressionDescription.expression = expression
        expressionDescription.expressionResultType = .integer64AttributeType

        fetchRequest.propertiesToFetch = [expressionDescription]

        var results: [NSDictionary] = []
        try context.performAndWait {
            results = try context.fetch(fetchRequest)
        }

        if let resultDict = results.first,
            let maxIndex = resultDict["maxIndex"] as? Int64
        {
            return maxIndex + 1
        } else {
            return 0
        }
    }
}
