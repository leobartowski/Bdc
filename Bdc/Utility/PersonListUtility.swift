//
//  Utility.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 22/10/21.
//

import Foundation
import CoreData
import UIKit

class PersonListUtility {
    
    public static let persons = createStartingPerson(CoreDataContainer.context)
    public static var personsWeeklyAttendance = createEmptyWeeklyAttendance()
    
    private static func createStartingPerson(_ context: NSManagedObjectContext) -> [Person] {
    
        let franco = Person(context: context)
        franco.name = "Franco"
        franco.iconString = "franco_icon"
        let fiore = Person(context: context)
        fiore.name = "Fiore"
        fiore.iconString = "fiore_icon"
        let sossio = Person(context: context)
        sossio.name = "Sossio"
        let mary = Person(context: context)
        mary.name = "Mary"
        mary.iconString = "mary_icon"
        let genny = Person(context: context)
        genny.name = "Genny"
        let raff = Person(context: context)
        raff.name = "Raff N"
        raff.iconString = "raff_icon"
        let giannetta = Person(context: context)
        giannetta.name = "Giannetta"
        giannetta.iconString = "giannetta_icon"
        let nero = Person(context: context)
        nero.name = "Nero"
        let cataldo = Person(context: context)
        cataldo.name = "Cataldo"
        let enzo = Person(context: context)
        enzo.name = "Enzo"
        let savio = Person(context: context)
        savio.name = "Savio Dj"
        let gigi = Person(context: context)
        gigi.name = "Gigi"
        gigi.iconString = "gigi_icon"
        let moda = Person(context: context)
        moda.name = "Moda"
        let pacokh = Person(context: context)
        pacokh.name = "Paco KH"
        let mattia = Person(context: context)
        mattia.name = "Mattia"
        let raffaella = Person(context: context)
        raffaella.name = "Raffaella"
        let franzese = Person(context: context)
        franzese.name = "Franzese"
        let lisa = Person(context: context)
        lisa.name = "Lisa"
        let danieled = Person(context: context)
        danieled.name = "Daniele D"
        let giovannir = Person(context: context)
        giovannir.name = "Giovanni R"
        let conte = Person(context: context)
        conte.name = "Conte"
        let alessia = Person(context: context)
        alessia.name = "Alessia"
        let michelep = Person(context: context)
        michelep.name = "Michele P"
        let angelo = Person(context: context)
        angelo.name = "Angelo"
        
        let persons = [franco, fiore, mary, raff, genny, gigi, giovannir, giannetta, enzo, cataldo, lisa, danieled, savio, nero, mattia, conte, raffaella, sossio, pacokh, moda, alessia, michelep, franzese, angelo]
        return persons
    }
    
    private static func createEmptyWeeklyAttendance() -> [PersonWeeklyAttendance] {
        var personsWeeklyAttendance = [PersonWeeklyAttendance]()
        for person in PersonListUtility.persons {
            let personAttendece = PersonWeeklyAttendance(person, 0)
            personsWeeklyAttendance.append(personAttendece)
        }
        return personsWeeklyAttendance
    }
    
    
}


public class PersonWeeklyAttendance {
    
    var person: Person
    var attendanceNumber: Int
    
    init(_ person: Person, _ attendanceNumber: Int ) {
        self.person = person
        self.attendanceNumber = attendanceNumber
    }
}
