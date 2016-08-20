//
//  ChecklistItem.swift
//  CheckList
//
//  Created by kemchenj on 4/17/16.
//  Copyright © 2016 kemchenj. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications



class ChecklistItem: NSObject, NSCoding
{
    var text         = ""
    var checked      = false
    var dueDate      = Date()
    var shouldRemind = false
    var itemID : Int
    
    override convenience init() {
        self.init(text: "", checked: false)
    }
    
    convenience init(text: String) {
        self.init(text: text, checked: false)
    }
    
    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
        self.itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    func toggleChecked() {
        checked = !checked
    }
    
    // MARK: - NSCoindg Protocol
    
    required init?(coder aDecoder: NSCoder) {
        text         = aDecoder.decodeObject(forKey: "Text") as! String
        checked      = aDecoder.decodeBool(forKey: "Checked")
        dueDate      = aDecoder.decodeObject(forKey: "DueDate") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        itemID       = aDecoder.decodeInteger(forKey: "ItemID")
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
        aCoder.encode(dueDate, forKey: "DueDate")
        aCoder.encode(shouldRemind, forKey: "ShouldRemind")
        aCoder.encode(itemID, forKey: "ItemID")
    }
}



// MARK: - Notification

extension ChecklistItem {
    
    func scheduleNotification() {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["\(itemID)"])
        
        if shouldRemind && dueDate.compare(Date()) != .orderedAscending {
            let trigger = UNCalendarNotificationTrigger.getTrigger(in: dueDate)
            
            let content = UNMutableNotificationContent()
            content.sound = UNNotificationSound.default()
            content.title = text
            content.subtitle = "     "
            content.body = "   "
            
            let request = UNNotificationRequest(identifier: "\(itemID)",
                                                content: content,
                                                trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
    }
    
}
