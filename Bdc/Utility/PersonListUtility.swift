//
//  Utility.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 22/10/21.
//

import CoreData
import Foundation
import UIKit

class PersonListUtility {
    
    public static var persons = CoreDataService.shared.getPersonsList() {
        didSet {
            PersonListUtility.rankingPersonsAttendance = createEmptyWeeklyAttendance()
            let notification = Notification(name: .didChangePersonList, object: nil, userInfo: nil)
            NotificationCenter.default.post(notification)
            
        }
    }
    public static var rankingPersonsAttendance = createEmptyWeeklyAttendance()

    static func createStartingPerson(_ context: NSManagedObjectContext) -> [Person] {
        let franco = Person(context: context)
        franco.name = "Franco"
        franco.iconString = "franco_icon"
        let fiore = Person(context: context)
        fiore.name = "Fiore"
        fiore.iconString = "fiore_icon"
        let sossio = Person(context: context)
        sossio.name = "Sossio"
        sossio.iconString = "sossio_icon"
        let mary = Person(context: context)
        mary.name = "Mary"
        mary.iconString = "mary_icon"
        let genny = Person(context: context)
        genny.name = "Genny"
        genny.iconString = "genny_icon"
        let raff = Person(context: context)
        raff.name = "Raff N"
        raff.iconString = "raff_icon"
        let giannetta = Person(context: context)
        giannetta.name = "Giannetta"
        giannetta.iconString = "giannetta_icon"
        let nero = Person(context: context)
        nero.name = "Nero"
        let cataldo = Person(context: context)
        cataldo.name = "Roberto"
        cataldo.iconString = "cataldo_icon"
        let enzo = Person(context: context)
        enzo.name = "Enzo"
        enzo.iconString = "enzo_icon"
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
        lisa.iconString = "lisa_icon"
        let danieled = Person(context: context)
        danieled.name = "Daniele D"
        danieled.iconString = "danieleD_icon"
        let giovannir = Person(context: context)
        giovannir.name = "Giovanni R"
        giovannir.iconString = "giovanniR_icon"
        let conte = Person(context: context)
        conte.name = "Conte"
        conte.iconString = "conte_icon"
        let alessia = Person(context: context)
        alessia.name = "Alessia"
        let michelep = Person(context: context)
        michelep.name = "Michele P"
        let angelo = Person(context: context)
        angelo.name = "Angelo"
        let francescoe = Person(context: context)
        francescoe.name = "Francesco E"

        let persons = [franco, fiore, mary, raff, genny, gigi, giovannir, giannetta, enzo, cataldo, lisa, danieled, savio, sossio, francescoe, nero, mattia, conte, raffaella, pacokh, moda, alessia, michelep, franzese, angelo]
        return persons
    }

    private static func createEmptyWeeklyAttendance() -> [RankingPersonAttendance] {
        var personsWeeklyAttendance = [RankingPersonAttendance]()
        for person in PersonListUtility.persons {
            let personAttendece = RankingPersonAttendance(person)
            personsWeeklyAttendance.append(personAttendece)
        }
        return personsWeeklyAttendance
    }
}

public class RankingPersonAttendance {
    var person: Person
    var attendanceNumber: Int = 0
    var admonishmentNumber: Int = 0
    var morningDate: [Date] = []
    var eveningDate: [Date] = []

    init(_ person: Person) {
        self.person = person
    }
}
