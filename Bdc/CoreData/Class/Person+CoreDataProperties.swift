//
//  Person+CoreDataProperties.swift
//
//
//  Created by Francesco D'Angelo on 27/11/21.
//
//

import Foundation
import CoreData

extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var iconString: String?
    @NSManaged public var name: String?
    @NSManaged public var difficultyCoefficient: Float
    @NSManaged public var attendance: NSSet?
    @NSManaged public var attendanceAdmonishment: Attendance?

}

// MARK: Generated accessors for attendance
extension Person {

    @objc(addAttendanceObject:)
    @NSManaged public func addToAttendance(_ value: Attendance)

    @objc(removeAttendanceObject:)
    @NSManaged public func removeFromAttendance(_ value: Attendance)

    @objc(addAttendance:)
    @NSManaged public func addToAttendance(_ values: NSSet)

    @objc(removeAttendance:)
    @NSManaged public func removeFromAttendance(_ values: NSSet)

}
