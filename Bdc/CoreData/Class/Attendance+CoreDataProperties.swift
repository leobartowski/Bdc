//
//  Attendance+CoreDataProperties.swift
//  
//
//  Created by Francesco D'Angelo on 27/11/21.
//
//

import Foundation
import CoreData


extension Attendance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attendance> {
        return NSFetchRequest<Attendance>(entityName: "Attendance")
    }

    @NSManaged public var dateString: String?
    @NSManaged public var type: String?
    @NSManaged public var persons: NSSet?
    @NSManaged public var personsAdmonished: NSSet?

}

// MARK: Generated accessors for persons
extension Attendance {

    @objc(addPersonsObject:)
    @NSManaged public func addToPersons(_ value: Person)

    @objc(removePersonsObject:)
    @NSManaged public func removeFromPersons(_ value: Person)

    @objc(addPersons:)
    @NSManaged public func addToPersons(_ values: NSSet)

    @objc(removePersons:)
    @NSManaged public func removeFromPersons(_ values: NSSet)

}

// MARK: Generated accessors for personsAdmonished
extension Attendance {

    @objc(addPersonsAdmonishedObject:)
    @NSManaged public func addToPersonsAdmonished(_ value: Person)

    @objc(removePersonsAdmonishedObject:)
    @NSManaged public func removeFromPersonsAdmonished(_ value: Person)

    @objc(addPersonsAdmonished:)
    @NSManaged public func addToPersonsAdmonished(_ values: NSSet)

    @objc(removePersonsAdmonished:)
    @NSManaged public func removeFromPersonsAdmonished(_ values: NSSet)

}
