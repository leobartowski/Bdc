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
    
    //MARK: Method to save
    
    ///Save  Person Admonished Attendence in Core Data for a specif date and daytype
    func saveAttendance(_ date: Date,_ type: DayType,_ persons: [Person]) {
        
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
    
    func saveAdmonishedAttendance(_ date: Date,_ type: DayType,_ personsAdmonished: [Person]) {
        
        var attendence = getAttendace(date, type: type)
        if attendence == nil {
            // Se è vuoto ne creo uno nuovo
            attendence = Attendance(context: context)
            attendence?.dateString = DateFormatter.basicFormatter.string(from: date)
            attendence?.type = type.rawValue
        }
        
        attendence?.personsAdmonished = NSSet(array: personsAdmonished)
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: Methods to fetch from Core Data
    
    ///Get Attendance for a specif day and daytype
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
    
    ///Get  persons that were present in a specif day and dayType
    func getPersonsPresent(_ date: Date, type: DayType) -> [Person] {
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
    ///Get  amonished persons in a specif day and dayType
    func getPersonsAmmonished(_ date: Date, type: DayType) -> [Person] {
        let fetchRequest = NSFetchRequest<Attendance>(entityName: "Attendance")
        let dateString = DateFormatter.basicFormatter.string(from: date)
        do {
            let attendances = try self.context.fetch(fetchRequest).filter({ $0.dateString == dateString && $0.type == type.rawValue })
            return attendances.first?.personsAdmonished?.allObjects as? [Person] ?? []
            
        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
        return []
    }
    
    // MARK: HandlePersons CoreData
    
    /// Retive all persons
    func getPersonsList() -> [Person] {
        let fetchRequest = NSFetchRequest<PersonsList>(entityName: "PersonsList")
        do {
            if let personsList = try self.context.fetch(fetchRequest).first {
                return personsList.persons?.allObjects as? [Person] ?? []
            }
            
        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
        return []
    }
    
    // MARK: Methods to update Person Properties
    
    /// Use this string to update/add imageString to a person
    func updateImageStringSpecificPerson(name: String, iconString: String) {
        let persons = getPersonsList()
        
        if let index = persons.firstIndex(where: { $0.name == name }) {
            persons[index].iconString = iconString
        }
        let fetchRequest = NSFetchRequest<PersonsList>(entityName: "PersonsList")
        do {
            if let personsList = try self.context.fetch(fetchRequest).first {
                personsList.persons = NSSet(array: persons)
            }
            
        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
    }
    
    ///Use this method to change persons name in PersonsList and to change all the previous records (the id of the person is name)
    func updateNameSpecificPerson(oldName: String, newName: String) {
        let persons = getPersonsList()
        
        if let index = persons.firstIndex(where: { $0.name == oldName }) {
            persons[index].name = newName
        }
        let fetchRequest = NSFetchRequest<PersonsList>(entityName: "PersonsList")
        do {
            if let personsList = try self.context.fetch(fetchRequest).first {
                personsList.persons = NSSet(array: persons)
                CoreDataService.shared.updateNameInOldRecords(oldName: oldName, newName: newName)
            }
            
        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
    }
    
    /// Search all the old records of the database and updates the name
    func updateNameInOldRecords(oldName: String, newName: String) {
        let fetchRequest = NSFetchRequest<Attendance>(entityName: "Attendance")
        do {
            let attendances = try self.context.fetch(fetchRequest)
            for attendance in attendances {
                if let persons = attendance.persons?.allObjects as? [Person] {
                    if let index = persons.firstIndex(where: { $0.name == oldName }) {
                        persons[index].name = newName
                    }
                }
            }
            try self.context.save()
            
        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
    }
    
    func removeAllAdmonishment() {
        
        let fetchRequest = NSFetchRequest<Attendance>(entityName: "Attendance")
        do {
            let attendances = try self.context.fetch(fetchRequest)
            for attendance in attendances {
                attendance.personsAdmonished = nil
            }
            try self.context.save()
            
        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
    }
    
    ///Use this  just one time to create the persons List on a new device!
    func createPersonsList() {

        clearPersonList() // Delete all the present List if there are
        let personsList: PersonsList = PersonsList(context: context)
        personsList.persons = NSSet(array: PersonListUtility.createStartingPerson(context))
        do {
            try self.context.save()
            
        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
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
    
    func clearPersonList() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PersonsList")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.context.execute(deleteRequest)
        
        } catch let error as NSError {
            print("Error:  \(error), \(error.userInfo)")
        }
    }
}

