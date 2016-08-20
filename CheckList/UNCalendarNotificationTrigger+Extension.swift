
//
//  UNCalendarNotificationTrigger.swift
//  CheckList
//
//  Created by kemchenj on 8/19/16.
//  Copyright © 2016 kemchenj. All rights reserved.
//

import Foundation
import UserNotifications

extension UNCalendarNotificationTrigger {
    
    static func getTrigger(in date: Date) -> UNCalendarNotificationTrigger {
        let remindCalender = Calendar(identifier: Calendar.Identifier.gregorian)
        let dateComponents = remindCalender.dateComponents(in: TimeZone(secondsFromGMT: 8 * 60 * 60)!, from: date)
        
        print("\(dateComponents.year)年\(dateComponents.month)月\(dateComponents.day)日\(dateComponents.hour)时\(dateComponents.minute)")
        
        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    }
}
