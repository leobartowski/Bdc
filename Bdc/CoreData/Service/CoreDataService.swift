//
//  CoreDataService.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 21/10/21.
//

import CoreData
import Foundation

class CoreDataService {
    
    static var shared = CoreDataService()

     var context: NSManagedObjectContext

    private init() {
        self.context = CoreDataContainer.context
    }

    // MARK: Method to save

    /// Save  Person Admonished Attendence in Core Data for a specif date and daytype
    func saveAttendance(_ attendence: inout Attendance?, _ date: Date, _ type: DayType, _ persons: [Person]) {
        if attendence == nil {
            attendence = Attendance(context: self.context)
            attendence?.dateString = DateFormatter.basicFormatter.string(from: date)
            attendence?.type = type.rawValue
        }
        attendence?.persons = NSSet(array: persons)
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func saveAdmonishedAttendance(_ attendence: inout Attendance?, _ date: Date, _ type: DayType, _ personsAdmonished: [Person]) {
        if attendence == nil {
            attendence = Attendance(context: self.context)
            attendence?.dateString = DateFormatter.basicFormatter.string(from: date)
            attendence?.type = type.rawValue
        }
        attendence?.personsAdmonished = NSSet(array: personsAdmonished)
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    // MARK: Methods to fetch from Core Data

    /// Get Attendance for a specif day and daytype
    func getAttendace(_ date: Date, type: DayType) -> Attendance? {
        let fetchRequest = NSFetchRequest<Attendance>(entityName: "Attendance")
        let dateString = DateFormatter.basicFormatter.string(from: date)
        do {
            fetchRequest.predicate = NSPredicate(format: "dateString == %@ AND type == %@", dateString, type.rawValue)
            let attendances = try context.fetch(fetchRequest)
            return attendances.first

        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func getAllAttendaces() -> [Attendance]? {
        let fetchRequest = NSFetchRequest<Attendance>(entityName: "Attendance")
        do {
            return try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func getAllAttendaces(for person: Person) -> [Attendance]? {
        let fetchRequest = NSFetchRequest<Attendance>(entityName: "Attendance")
        fetchRequest.predicate = NSPredicate(format: "ANY persons.name == %@", person.name ?? "")
        do {
            return try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
        return nil
    }

    /// Get  persons that were present in a specif day and dayType
    func getPersonsPresent(_ date: Date, type: DayType) -> [Person] {
        let fetchRequest = NSFetchRequest<Attendance>(entityName: "Attendance")
        let dateString = DateFormatter.basicFormatter.string(from: date)
        do {
            fetchRequest.predicate = NSPredicate(format: "dateString == %@ AND type == %@", dateString, type.rawValue)
            let attendances = try context.fetch(fetchRequest)
            return attendances.first?.persons?.allObjects as? [Person] ?? []

        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
        return []
    }

    /// Get  amonished persons in a specif day and dayType
    func getPersonsAmmonished(_ date: Date, type: DayType) -> [Person] {
        let fetchRequest = NSFetchRequest<Attendance>(entityName: "Attendance")
        let dateString = DateFormatter.basicFormatter.string(from: date)
        do {
            fetchRequest.predicate = NSPredicate(format: "dateString == %@ AND type == %@", dateString, type.rawValue)
            let attendances = try context.fetch(fetchRequest)
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
            if let personsList = try context.fetch(fetchRequest).first {
                let personList = personsList.persons?.allObjects as? [Person] ?? []
                return personList.sorted { $0.name ?? "" < $1.name ?? "" }
            }
            
        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
        return []
    }
    
    func getPersonIconString(for personName: String) -> String {
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        fetchRequest.predicate = NSPredicate(format: "name == %@", personName)
        fetchRequest.fetchLimit = 1
        do {
            if let person = try context.fetch(fetchRequest).first {
                return person.iconString ?? ""
            }
        } catch let error as NSError {
            print("Could not fetch person. \(error), \(error.userInfo)")
        }
        return ""
    }

    func deletePersonFromPersonsList(name: String? = "") {
        
        let fetchRequest = NSFetchRequest<PersonsList>(entityName: "PersonsList")
        do {
            if let personsList = try context.fetch(fetchRequest).first {
                
                for person in personsList.persons?.allObjects as? [Person] ?? [] where person.name == name {
                    self.context.delete(person)
                }
                try self.context.save()
                PersonListUtility.persons = self.getPersonsList()
            }
        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: Methods to update Person Properties

    /// Use this string to update/add imageString to a person
    func updateImageStringSpecificPerson(name: String, iconString: String) {
        let persons = self.getPersonsList()

        if let index = persons.firstIndex(where: { $0.name == name }) {
            persons[index].iconString = iconString
        }
        let fetchRequest = NSFetchRequest<PersonsList>(entityName: "PersonsList")
        do {
            if let personsList = try context.fetch(fetchRequest).first {
                personsList.persons = NSSet(array: persons)
                
                try self.context.save()
            }

        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
    }

    /// Use this method to change persons name in PersonsList and to change all the previous records (the id of the person is name)
    func updateNameSpecificPerson(oldName: String, newName: String) {
        let persons = self.getPersonsList()

        if let index = persons.firstIndex(where: { $0.name == oldName }) {
            persons[index].name = newName
        }
        let fetchRequest = NSFetchRequest<PersonsList>(entityName: "PersonsList")
        do {
            if let personsList = try context.fetch(fetchRequest).first {
                personsList.persons = NSSet(array: persons)
                try self.context.save()
                CoreDataService.shared.updateNameInOldRecords(oldName: oldName, newName: newName)
            }

        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
    }
    
    /// Use this method to change persons name in PersonsList and to change all the previous records (the id of the person is name)
    func updateDifficultCoefficencyToEveryOne() {
        let persons = self.getPersonsList()
        for person in persons {
            person.difficultyCoefficient = PersonListUtility.getDifficultyCoefficient(person)
        }
        let fetchRequest = NSFetchRequest<PersonsList>(entityName: "PersonsList")
        do {
            if let personsList = try context.fetch(fetchRequest).first {
                personsList.persons = NSSet(array: persons)
                try self.context.save()
            }

        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
    }

    /// Search all the old records of the database and updates the name
    func updateNameInOldRecords(oldName: String, newName: String) {
        let fetchRequest = NSFetchRequest<Attendance>(entityName: "Attendance")
        do {
            let attendances = try context.fetch(fetchRequest)
            for attendance in attendances {
                if let persons = attendance.persons?.allObjects as? [Person] {
                    if let index = persons.firstIndex(where: { $0.name == oldName }) {
                        persons[index].name = newName
                    }
                }
            }
            try self.context.save()
            PersonListUtility.persons = self.getPersonsList()

        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
    }

    func removeAllAdmonishment() {
        let fetchRequest = NSFetchRequest<Attendance>(entityName: "Attendance")
        do {
            let attendances = try context.fetch(fetchRequest)
            for attendance in attendances {
                attendance.personsAdmonished = nil
            }
            try self.context.save()

        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
    }
    
//    func removeAllPresenceOf(name: String) {
//        let fetchRequest = NSFetchRequest<Attendance>(entityName: "Attendance")
//        do {
//            let attendances = try context.fetch(fetchRequest)
//            for attendance in attendances {
//                for person in attendance.persons where person.name == name {
//
//                }
//                attendance.personsAdmonished = nil
//            }
//            try self.context.save()
//
//        } catch let error as NSError {
//            print("Could not list. \(error), \(error.userInfo)")
//        }
//    }

    /// Use this  just one time to create the persons List on a new device!
    func createPersonsListIfNeeded(_ persons: [Person] = []) {
        let currentPersons = CoreDataService.shared.getPersonsList()
        if currentPersons.isEmpty {
            self.clearPersonList() // Delete all the present List if there are
            let personsList = PersonsList(context: context)
            personsList.persons = NSSet(array: persons.isEmpty ? PersonListUtility.createStartingPerson(self.context) : persons)
            do {
                try self.context.save()
                
            } catch let error as NSError {
                print("Could not list. \(error), \(error.userInfo)")
            }
        }
    }
    
    func addPersonToPersonList(_ person: Person) {
        let fetchRequest = NSFetchRequest<PersonsList>(entityName: "PersonsList")
        do {
            if let personsList = try context.fetch(fetchRequest).first {
                var persons = personsList.persons?.allObjects as? [Person] ?? []
                persons.append(person)
                personsList.persons = NSSet(array: persons)
                try self.context.save()
                PersonListUtility.persons = self.getPersonsList()
            }

        } catch let error as NSError {
            print("Could not list. \(error), \(error.userInfo)")
        }
    }

    // MARK: WARNING

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

    func deleteSpecificAttendance(_ dateString: String) -> Bool {
        let fetchRequest = NSFetchRequest<Attendance>(entityName: "Attendance")
        fetchRequest.predicate = NSPredicate(format: "dateString == %@", dateString)
        do {
            let attendances = try context.fetch(fetchRequest)
            for attendance in attendances {
                context.delete(attendance)
            }
            try context.save()
        } catch let error as NSError {
            print("Could not delete attendance. \(error), \(error.userInfo)")
            return false
        }
        return true
    }
    
    /// Prints all the days with more than 2 att objects (SHOULD BE ZERO)
    func checkIfThereAreMultipleAttendanceForASlot() {
        let atts = self.getAllAttendaces() ?? []
        var dict: [String: Int] = [:]
        for att in atts {
            dict[att.dateString ?? "", default: 0] += 1
        }
        let filtered = dict.filter { $0.value > 2}
        print(filtered)
    }
}
