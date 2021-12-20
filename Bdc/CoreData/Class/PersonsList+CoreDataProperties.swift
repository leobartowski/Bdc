//
//  PersonsList+CoreDataProperties.swift
//
//
//  Created by Francesco D'Angelo on 25/11/21.
//
//

import CoreData
import Foundation

public extension PersonsList {
    @nonobjc class func fetchRequest() -> NSFetchRequest<PersonsList> {
        return NSFetchRequest<PersonsList>(entityName: "PersonsList")
    }

    @NSManaged var persons: NSSet?
}

// MARK: Generated accessors for persons

public extension PersonsList {
    @objc(addPersonsObject:)
    @NSManaged func addToPersons(_ value: Person)

    @objc(removePersonsObject:)
    @NSManaged func removeFromPersons(_ value: Person)

    @objc(addPersons:)
    @NSManaged func addToPersons(_ values: NSSet)

    @objc(removePersons:)
    @NSManaged func removeFromPersons(_ values: NSSet)
}
