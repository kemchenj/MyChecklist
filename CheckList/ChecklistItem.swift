//
//  ChecklistItem.swift
//  CheckList
//
//  Created by kemchenj on 4/17/16.
//  Copyright © 2016 kemchenj. All rights reserved.
//

import Foundation
import UIKit


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
    
    
    
    // MARK: - Notification
    
    func scheduleNotification() {
        let existingNotification = notificationForThisItem()
        if let notification = existingNotification {
            print("Found an existing notification \(notification)")
            UIApplication.shared.cancelLocalNotification(notification)
        }
        
        if shouldRemind && dueDate.compare(Date()) != .orderedAscending {
            let localNotification = UILocalNotification()
            
            localNotification.fireDate  = dueDate
            localNotification.timeZone  = TimeZone.autoupdatingCurrent
            localNotification.alertBody = text
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.userInfo  = ["ItemID": itemID]
            
            UIApplication.shared.scheduleLocalNotification(localNotification)
            
            print("Scheduled notification \(localNotification) for itemID \(itemID)")
        }
    }
    
    func notificationForThisItem() -> UILocalNotification? {
        let allNotifications = UIApplication.shared.scheduledLocalNotifications!
        for notification in allNotifications {
            if (notification.userInfo?["itemID"] as? Int) != nil {
                return notification
            }
        }
        return nil
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
    
    deinit{
        if let notification = notificationForThisItem() {
            print("Removing existing notification \(notification)")
            UIApplication.shared.cancelLocalNotification(notification)
        }
    }
}
