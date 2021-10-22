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
        var attendence = getAttendace(date, type: type)
        if attendence == nil {
            // Se è vuoto ne creo uno nuovo
            attendence = Attendance(context: context)
            attendence?.dateString = DateFormatter.basicFormatter.string(from: date)
            attendence?.type = type.rawValue
        }
        attendence?.persons = NSSet(array: persons)
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getAttendace(_ date: Date, type: DayType) -> Attendance? {
        let fetchRequest = NSFetchRequest<Attendance>(entityName: "Attendance")
        let dateString = DateFormatter.basicFormatter.string(from: date)
        do {
            let attendances = try self.context.fetch(fetchRequest).filter({ $0.dateString == dateString && $0.type == type.rawValue })
            return attendances.first
            
        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    ///Get  Attendence from Core Data
    func getAttendancePerson(_ date: Date, type: DayType) -> [Person] {
        let fetchRequest = NSFetchRequest<Attendance>(entityName: "Attendance")
        let dateString = DateFormatter.basicFormatter.string(from: date)
        do {
            let attendances = try self.context.fetch(fetchRequest).filter({ $0.dateString == dateString && $0.type == type.rawValue })
            return attendances.first?.persons?.allObjects as? [Person] ?? []
            
        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
        return []
        
    }
    
    //MARK: WARNING
    /// Use this method when you want to DELETE EVERYTHING from the Database
    func cleanCoreDataDataBase() {

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Attendance")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Person")
        let deleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)

        do {
            try self.context.execute(deleteRequest)
            try self.context.execute(deleteRequest2)
        } catch let error as NSError {
            print("Error:  \(error), \(error.userInfo)")
        }

    }
}

