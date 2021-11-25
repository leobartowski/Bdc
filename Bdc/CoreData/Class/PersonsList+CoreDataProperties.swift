//
//  PersonsList+CoreDataProperties.swift
//  
//
//  Created by Francesco D'Angelo on 25/11/21.
//
//

import Foundation
import CoreData


extension PersonsList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonsList> {
        return NSFetchRequest<PersonsList>(entityName: "PersonsList")
    }

    @NSManaged public var persons: NSSet?

}

// MARK: Generated accessors for persons
extension PersonsList {

    @objc(addPersonsObject:)
    @NSManaged public func addToPersons(_ value: Person)

    @objc(removePersonsObject:)
    @NSManaged public func removeFromPersons(_ value: Person)

    @objc(addPersons:)
    @NSManaged public func addToPersons(_ values: NSSet)

    @objc(removePersons:)
    @NSManaged public func removeFromPersons(_ values: NSSet)

}
