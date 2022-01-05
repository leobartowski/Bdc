//
//  Attendance+CoreDataProperties.swift
//
//
//  Created by Francesco D'Angelo on 27/11/21.
//
//

import CoreData
import Foundation

public extension Attendance {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Attendance> {
        return NSFetchRequest<Attendance>(entityName: "Attendance")
    }

    @NSManaged var dateString: String?
    @NSManaged var type: String?
    @NSManaged var persons: NSSet?
    @NSManaged var personsAdmonished: NSSet?
}

// MARK: Generated accessors for persons

public extension Attendance {
    @objc(addPersonsObject:)
    @NSManaged func addToPersons(_ value: Person)

    @objc(removePersonsObject:)
    @NSManaged func removeFromPersons(_ value: Person)

    @objc(addPersons:)
    @NSManaged func addToPersons(_ values: NSSet)

    @objc(removePersons:)
    @NSManaged func removeFromPersons(_ values: NSSet)
}

// MARK: Generated accessors for personsAdmonished

public extension Attendance {
    @objc(addPersonsAdmonishedObject:)
    @NSManaged func addToPersonsAdmonished(_ value: Person)

    @objc(removePersonsAdmonishedObject:)
    @NSManaged func removeFromPersonsAdmonished(_ value: Person)

    @objc(addPersonsAdmonished:)
    @NSManaged func addToPersonsAdmonished(_ values: NSSet)

    @objc(removePersonsAdmonished:)
    @NSManaged func removeFromPersonsAdmonished(_ values: NSSet)
}
