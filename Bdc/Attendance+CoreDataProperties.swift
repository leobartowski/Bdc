//
//  Attendance+CoreDataProperties.swift
//
//
//  Created by Francesco D'Angelo on 21/10/21.
//
//

import CoreData
import Foundation

public extension Attendance {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Attendance> {
        return NSFetchRequest<Attendance>(entityName: "Attendance")
    }

    @NSManaged var date: Date?
    @NSManaged var persons: NSSet?
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
