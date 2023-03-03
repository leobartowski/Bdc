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
        franco.difficultyCoefficient = DifficultyCoefficient.easy.rawValue
        let fiore = Person(context: context)
        fiore.name = "Fiore"
        fiore.iconString = "fiore_icon"
        fiore.difficultyCoefficient = DifficultyCoefficient.easy.rawValue
        let sossio = Person(context: context)
        sossio.name = "Sossio"
        sossio.iconString = "sossio_icon"
        sossio.difficultyCoefficient = DifficultyCoefficient.hard.rawValue
        let mary = Person(context: context)
        mary.name = "Mary"
        mary.iconString = "mary_icon"
        mary.difficultyCoefficient = DifficultyCoefficient.medium.rawValue
        let genny = Person(context: context)
        genny.name = "Gennaro"
        genny.iconString = "genny_icon"
        genny.difficultyCoefficient = DifficultyCoefficient.medium.rawValue
        let raff = Person(context: context)
        raff.name = "Raff N"
        raff.iconString = "raff_icon"
        raff.difficultyCoefficient = DifficultyCoefficient.medium.rawValue
        let giannetta = Person(context: context)
        giannetta.name = "Giannetta"
        giannetta.iconString = "giannetta_icon"
        giannetta.difficultyCoefficient = DifficultyCoefficient.easy.rawValue
        let cataldo = Person(context: context)
        cataldo.name = "Roberto"
        cataldo.iconString = "cataldo_icon"
        cataldo.difficultyCoefficient = DifficultyCoefficient.medium.rawValue
        let enzo = Person(context: context)
        enzo.name = "Enzo"
        enzo.iconString = "enzo_icon"
        enzo.difficultyCoefficient = DifficultyCoefficient.easy.rawValue
        let savio = Person(context: context)
        savio.name = "Savio Dj"
        savio.iconString = "dj_icon"
        savio.difficultyCoefficient = DifficultyCoefficient.easy.rawValue
        let gigi = Person(context: context)
        gigi.name = "Gigi"
        gigi.iconString = "gigi_icon"
        gigi.difficultyCoefficient = DifficultyCoefficient.easy.rawValue
        let pacokh = Person(context: context)
        pacokh.name = "Paco KH"
        pacokh.iconString = "paco_icon"
        pacokh.difficultyCoefficient = DifficultyCoefficient.hard.rawValue
        let mattia = Person(context: context)
        mattia.name = "Mattia"
        mattia.iconString = "mattia_icon"
        mattia.difficultyCoefficient = DifficultyCoefficient.medium.rawValue
        let franzese = Person(context: context)
        franzese.name = "Franzese"
        franzese.iconString = "franzese_icon"
        franzese.difficultyCoefficient = DifficultyCoefficient.medium.rawValue
        let lisa = Person(context: context)
        lisa.name = "Lisa"
        lisa.iconString = "lisa_icon"
        lisa.difficultyCoefficient = DifficultyCoefficient.medium.rawValue
        let danieled = Person(context: context)
        danieled.name = "Daniele D"
        danieled.iconString = "danieleD_icon"
        danieled.difficultyCoefficient = DifficultyCoefficient.medium.rawValue
        let giovannir = Person(context: context)
        giovannir.name = "Giovanni R"
        giovannir.iconString = "giovanniR_icon"
        let conte = Person(context: context)
        conte.name = "Conte"
        conte.iconString = "conte_icon"
        let alessia = Person(context: context)
        alessia.name = "Alessia"
        alessia.iconString = "alessia_icon"
        alessia.difficultyCoefficient = DifficultyCoefficient.easy.rawValue
        let michelep = Person(context: context)
        michelep.name = "Michele P"
        michelep.iconString = "michele_p_icon"
        michelep.difficultyCoefficient = DifficultyCoefficient.easy.rawValue
        let francescoe = Person(context: context)
        francescoe.name = "Francesco E"
        francescoe.difficultyCoefficient = DifficultyCoefficient.medium.rawValue
        francescoe.iconString = "francesco_e_icon"
        let marika = Person(context: context)
        marika.name = "Marika"
        marika.difficultyCoefficient = DifficultyCoefficient.medium.rawValue
        marika.iconString = "marika_icon"
        let totore = Person(context: context)
        totore.name = "Marika"
        totore.difficultyCoefficient = DifficultyCoefficient.easy.rawValue
        totore.iconString = "totore_icon"
        
        let persons = [
            franco, fiore, mary, raff, genny, gigi, giovannir, giannetta, enzo, cataldo, lisa, danieled,
            savio, sossio, francescoe, mattia, conte, pacokh, alessia, michelep, franzese, marika, totore
        ]
        return persons
    }
    
    public static func getDifficultyCoefficient(_ person: Person) -> Float {
        switch person.name {
        case "Lisa", "Daniele D", "Mary", "Gennaro", "Raff N", "Roberto", "Francesco E",
            "Francesca T", "Conte", "Marika", "Giuseppe T", "Mattia", "Franzese",
            "Gaetano B", "Pasquale B", "Pasqualo", "Rossella", "Serena":
            return 1.3
        case "Paco KH", "Sossio": return 1.5
        default: return 1
        }
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
    var possibleAttendanceNumber: Int = 0
    var admonishmentNumber: Int = 0
    var morningDate: [Date] = []
    var eveningDate: [Date] = []
    var morningAdmonishmentDate: [Date] = []
    var eveningAdmonishmentDate: [Date] = []

    init(_ person: Person) {
        self.person = person
    }
}

public enum DifficultyCoefficient: Float {
    
    case easy = 1.0
    case medium = 1.3
    case hard = 1.4
}
