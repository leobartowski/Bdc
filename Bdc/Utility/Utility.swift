//
//  Utility.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 22/10/21.
//

import Foundation
import CoreData

class Utility {
    
    public static let persons = createStartingPerson(CoreDataContainer.context)
    
    public static func createStartingPerson(_ context: NSManagedObjectContext) -> [Person] {
    
        let person1 = Person(context: context)
        person1.name = "Franco"
        let person2 = Person(context: context)
        person2.name = "Fiore"
        let person3 = Person(context: context)
        person3.name = "Sossio"
        let person4 = Person(context: context)
        person4.name = "Mary"
        let person5 = Person(context: context)
        person5.name = "Genny"
        let person6 = Person(context: context)
        person6.name = "Raff"
        let person7 = Person(context: context)
        person7.name = "Giannetta"
        let person8 = Person(context: context)
        person8.name = "Nero"
        let person9 = Person(context: context)
        person9.name = "Enzo"
        let person10 = Person(context: context)
        person10.name = "Savio Dj"
        let person11 = Person(context: context)
        person11.name = "Gigi"
        let person12 = Person(context: context)
        person12.name = "Moda"
        let person13 = Person(context: context)
        person13.name = "Paco KH"
        let person14 = Person(context: context)
        person14.name = "Mattia"
        let person15 = Person(context: context)
        person15.name = "Raffaella"
        let person16 = Person(context: context)
        person16.name = "Franzese"
        let person17 = Person(context: context)
        person17.name = "Lisa"
        let person18 = Person(context: context)
        person18.name = "Daniele D"
        let person19 = Person(context: context)
        person19.name = "Giovanni R"
        
        let persons = [person1, person2, person3, person4, person5, person6, person7, person8, person9, person10, person11, person12, person13, person14, person15, person16, person17, person18, person19]
        return persons
    }
}
