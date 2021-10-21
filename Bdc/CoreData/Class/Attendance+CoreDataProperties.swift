//
//  Attendance+CoreDataProperties.swift
//  
//
//  Created by Francesco D'Angelo on 21/10/21.
//
//

import Foundation
import CoreData


extension Attendance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attendance> {
        return NSFetchRequest<Attendance>(entityName: "Attendance")
    }

    @NSManaged public var date: Date?
    @NSManaged public var type: String?
    @NSManaged public var persons: NSSet?

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

public enum DayType: String {
    case morning
    case evening
}
