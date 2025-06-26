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
    func saveIfNotExists(_ dto: RandomUserDTO) throws
    func softDeleteUser(byEmail email: String) throws
    func getNextIndex() throws -> Int64
}


final class RandomUserStorageQuery: RandomUserStorageQueryProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchUser(byEmail email: String) throws -> RandomUserEntity? {
        let request: NSFetchRequest<RandomUserEntity> = RandomUserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email)
        return try context.fetch(request).first
    }
    
    func fetchUsers(offset: Int, limit: Int) throws -> [RandomUserEntity] {
        let request: NSFetchRequest<RandomUserEntity> = RandomUserEntity.fetchRequest()
            request.predicate = NSPredicate(format: "deleted == %@", NSNumber(value: false))
            request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
            request.fetchOffset = offset
            request.fetchLimit = limit
        return try context.fetch(request)
    }
    

    func saveIfNotExists(_ dto: RandomUserDTO) throws {
        if let _ = try fetchUser(byEmail: dto.email) {
            return
        }
        let nextIndex = try getNextIndex()
        let entity = RandomUserEntity(context: context)
        entity.update(from: dto, index: nextIndex)
        try context.save()
    }

    func softDeleteUser(byEmail email: String) throws {
        guard let entity = try fetchUser(byEmail: email) else { return }
        entity.deleted = true
        try context.save()
    }

    func getNextIndex() throws -> Int64 { //Use max on NSDictionary fetch instead of filter by index for performance/efficience reason
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "RandomUserEntity")
        fetchRequest.resultType = .dictionaryResultType

        let expression = NSExpression(forFunction: "max:", arguments: [NSExpression(forKeyPath: "index")])
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "maxIndex"
        expressionDescription.expression = expression
        expressionDescription.expressionResultType = .integer64AttributeType

        fetchRequest.propertiesToFetch = [expressionDescription]

        let results = try context.fetch(fetchRequest)

        if let resultDict = results.first,
           let maxIndex = resultDict["maxIndex"] as? Int64 {
            return maxIndex + 1
        } else {
            return 0
        }
    }
}
