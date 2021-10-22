//
//  CoreDataService.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 21/10/21.
//

import Foundation
import CoreData

class CoreDataService {
    
    static var shared = CoreDataService()
    
    private var context: NSManagedObjectContext
    
    private init() {
        self.context = CoreDataContainer.context
    }
    
    ///Save Attendence in Core Data
    func saveAttendance(_ date: Date, _ persons: [Person], _ type: DayType) {
        let attendence = Attendance(context: context)
        attendence.dateString = DateFormatter.basicFormatter.string(from: date)
        attendence.type = type.rawValue
        attendence.persons = NSSet(array: persons)
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    ///Get  Attendence from Core Data
    func getAttendance(_ date: Date, type: DayType) -> [Person] {
        let fetchRequest = NSFetchRequest<Attendance>(entityName: "Attendance")
        let dateString = DateFormatter.basicFormatter.string(from: date)
        do {
            var attendances = try self.context.fetch(fetchRequest)
            attendances = attendances.filter { element in
                if element.dateString == dateString && element.type == type.rawValue {
                    return true
                }
                return false
            }
            return attendances.first?.persons?.allObjects as? [Person] ?? []
            
        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
        return []
        
    }
    
    func getAttendanceAndCreatePersonListIfNedded(_ date: Date) -> [Person] {
        let fetchRequest = NSFetchRequest<Attendance>(entityName: "Attendance")
        let dateString = DateFormatter.basicFormatter.string(from: date)
        do {
            var attendances = try self.context.fetch(fetchRequest)
            attendances = attendances.filter { element in
                if element.dateString == dateString {
                    return true
                } else {
                    Utility.createStartingPerson(self.context)
                }
                return false
            }
            return attendances.first?.persons?.allObjects as? [Person] ?? []
            
        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
        return []
    }


    
}
