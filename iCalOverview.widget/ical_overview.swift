//
//  main.swift
//  CalendarTool
//
//  Created by Benjamin Kunke on 04/11/14.
//  Copyright (c) 2014 Benjamin Kunke. All rights reserved.
//

import Foundation
import EventKit

//legt eine Instanz von EKEventStore an, analog zu ObjectiveC: EKEventStore* store = [[EKEventStore alloc]init];
var store = EKEventStore()


// Erfragt Zugang zu Entities vom Typ "Event" lokalen Store, gibt Erfolg in "granted: bool" zurück + evtl Fehlermeldung in "error: NSError"
store.requestAccessToEntityType(EKEntityTypeEvent, completion: {
    granted, error in
})

//Leerzeile
println()

//Legt ein Array mit allen Kalendern vom Typ "Event" an , Typ Kalender gefordert...
var calendars  = store.calendarsForEntityType(EKEntityTypeEvent) as [EKCalendar]

//...damit muss der Datentyp für calendar hier nicht spezifiziert werden...
for calendar in calendars
{
    //...sondern es kann direkt auf die member von EKCalendar zugegriffen werden.
    println("\(calendar.title!):")

    //vor 3 Tagen
    var startDate : NSDate = NSDate().dateByAddingTimeInterval(-60*60*24*3)
    
    //in 3 Tagen
    var endDate : NSDate = NSDate().dateByAddingTimeInterval(60*60*24*3)
    
    //Legt ein NSPredicate für Events an (hier: Startdatum, Enddatum, zu durchsuchendes Kalenderarray) , NSPredicate bietet viele Möglichkeiten Collections zu durchsuchen: http://nshipster.com/nspredicate/

    var predicate = store.predicateForEventsWithStartDate( startDate,
        endDate: endDate,
        calendars: [calendar])

    //analog zu den Kalendern alle events, die dem Prädikat entsprechen
    var events = store.eventsMatchingPredicate(predicate) as [EKEvent]

    for event in events
    {
        //Ausgabe event.title, startDate, endDate
        println("   \(event.title) (von \(event.startDate) bis \(event.endDate))")
    }

}





