//
//  CoreDateContainer.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 21/10/21.
//

import CoreData
import Foundation

class CoreDataContainer {
    
    public static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    public static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Bdc")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    public static func saveContext() {
        let context = self.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
