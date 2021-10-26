//
//  Attendance+CoreDataProperties.swift
//  
//
//  Created by Francesco D'Angelo on 26/10/21.
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
    @NSManaged public var warningPersons: NSSet?

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

// MARK: Generated accessors for warningPersons
extension Attendance {

    @objc(addWarningPersonsObject:)
    @NSManaged public func addToWarningPersons(_ value: Person)

    @objc(removeWarningPersonsObject:)
    @NSManaged public func removeFromWarningPersons(_ value: Person)

    @objc(addWarningPersons:)
    @NSManaged public func addToWarningPersons(_ values: NSSet)

    @objc(removeWarningPersons:)
    @NSManaged public func removeFromWarningPersons(_ values: NSSet)

}
