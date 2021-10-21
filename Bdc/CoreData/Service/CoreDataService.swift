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
        let attendence = Attendance()
        attendence.date = date
        attendence.type = type.rawValue
        attendence.persons = persons as? NSSet
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    ///Get  Attendence from Core Data
    func getAttendance(_ date: Date, type: DayType) -> [Person] {
        let fetchRequest = NSFetchRequest<Attendance>(entityName: "Attendance")
        do {
            var attendances = try self.context.fetch(fetchRequest)
            attendances = attendances.filter { element in
                if element.date == date && element.type == type.rawValue {
                    return true
                }
                return false
            }
            return attendances.first?.persons ?? []
            
        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
        
        return []
        
    }
    
}
