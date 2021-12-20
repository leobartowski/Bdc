//
//  Person+CoreDataProperties.swift
//
//
//  Created by Francesco D'Angelo on 21/10/21.
//
//

import CoreData
import Foundation

public extension Person {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged var name: String?
    @NSManaged var attendance: NSSet?
}

// MARK: Generated accessors for attendance

public extension Person {
    @objc(addAttendanceObject:)
    @NSManaged func addToAttendance(_ value: Attendance)

    @objc(removeAttendanceObject:)
    @NSManaged func removeFromAttendance(_ value: Attendance)

    @objc(addAttendance:)
    @NSManaged func addToAttendance(_ values: NSSet)

    @objc(removeAttendance:)
    @NSManaged func removeFromAttendance(_ values: NSSet)
}
