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

//Gregorianischer Kalender
let nsCalendar = NSCalendar.currentCalendar()

var dateFormatterDatum : NSDateFormatter = NSDateFormatter()
dateFormatterDatum.dateFormat = "dd.MM.yyyy"

var dateFormatterUhrzeit : NSDateFormatter = NSDateFormatter()
dateFormatterUhrzeit.dateFormat = "HH:mm"

var calendar : EKCalendar


var firstDay = true


/*

JSON - Syntax:

EndergebnisArray:           [datumObject1, datumObject2,...]
datumobject:                {datum : [calendarObject1, calendarObject2,...]}
calendarObject:             {Kalendertitel : [eventObject1, eventObject2,...]}
eventObject:                {start:Uhrzeit, ende: Uhrzeit, titel: Eventtitel}

*/




//Macht aus einem EKEvent ein eventObject mit titel, startzeit und endzeit

func eventObjectForEvent(event: EKEvent) -> String
{
    var eventString = "{"
    //println("    titel: \(event.title)")
    eventString += "\"titel\": \"\(event.title)\","
    
    //println("    start: \(dateFormatterUhrzeit.stringFromDate(event.startDate))")
    eventString += "\"start\": \"\(dateFormatterUhrzeit.stringFromDate(event.startDate))\","
    
    //println("    ende: \(dateFormatterUhrzeit.stringFromDate(event.endDate))")
    eventString += "\"ende\": \"\(dateFormatterUhrzeit.stringFromDate(event.endDate))\""
    
    eventString += "}"
    
    return eventString
}


//Macht aus einem EKEvent-Array ein JSON Array
func eventArrayForEvents(events:[EKEvent]) -> String
{
    var eventArrayString = "["
    
    var firstEvent = true
    for event in events
    {
        if !firstEvent {eventArrayString += ","}
        else {firstEvent = false}
        eventArrayString += eventObjectForEvent(event)
    }
    
    eventArrayString += "]"
    
    return eventArrayString
}

//Macht aus Startdatum, Enddatum und EKCalendar ein calendarObject (leer falls keine Events vorhanden)
func calendarObjectForStartDate(startDate: NSDate, endDate: NSDate, calendar: EKCalendar) -> String
{
    var calendarObjectString: String
    
    let predicate = store.predicateForEventsWithStartDate( startDate,
        endDate: endDate,
        calendars: [calendar])
    
    let events = store.eventsMatchingPredicate(predicate) as [EKEvent]
    
    let eventArrayString = eventArrayForEvents(events)
    
    if(eventArrayString == "[]")
    {
        calendarObjectString = ""
    }
    else
    {
        calendarObjectString = "{\"\(calendar.title)\":\(eventArrayString)}"
    }
    return calendarObjectString
}

//Liefert ein JSON Array aus calendarObjects

func calendarArrayForDate(startDate: NSDate, endDate: NSDate,calendars:[EKCalendar]) -> String
{
    var calendarArrayString = "["
    
    var firstCalendar = true
    for calendar in calendars
    {
        let calendarObject = calendarObjectForStartDate(startDate, endDate, calendar)
        

            if calendarObject != ""
            {
                if !firstCalendar{calendarArrayString += ","}
                else {firstCalendar = false}
                calendarArrayString += calendarObject
            }
    }
    
    calendarArrayString += "]"
    
    return calendarArrayString
}


// hier beginnt die Ausführung:


for var day: Int = 0; day <= 4; day++
{
    

    
    let date = NSDate().dateByAddingTimeInterval(NSTimeInterval(24*60*60*day))
    var components = nsCalendar.components( .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: date)
        
    let startDate = nsCalendar.dateFromComponents(components)
        
    components.day += 1
    let endDate = nsCalendar.dateFromComponents(components)
    
    println(dateFormatterDatum.stringFromDate(date))
    
    for calendar in calendars
    {
        println(calendarObjectForStartDate(startDate!, endDate!, calendar))
    }
}
















