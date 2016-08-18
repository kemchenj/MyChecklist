//
//  DataModel.swift
//  CheckList
//
//  Created by kemchenj on 5/3/16.
//  Copyright © 2016 kemchenj. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    var indexOfSelectedChecklist : Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    

    init() {
        loadChecklists()
        registerDefaults()
        handleTheFirstTime()
    }
    
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        
        return itemID
    }
    
    
    
    // MARK: - UserDefaults Settings

    func registerDefaults() {
        let dictionary = [ "ChecklistIndex"  : -1 ,
                           "FirstTime"       : true,
                           "ChecklistItemID" : 0
        ] as [String : Any]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleTheFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
        
    }

    func sortChecklists() {
        lists.sort(by: { checklist1, checklist2 in return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending })
    }
    
    
    
    // MARK: - Checklist Data OP

    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)

        archiver.encode(lists, forKey: "Checklists")
        archiver.finishEncoding()

        data.write(toFile: dataFilePath(), atomically: true)
    }

    func loadChecklists() {
        let path = dataFilePath()
        if FileManager.default.fileExists(atPath: path) {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
                unarchiver.finishDecoding()
                
                sortChecklists()
            }
        }
    }

    func documentDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }

    func dataFilePath() -> String {
        return (documentDirectory() as NSString).appendingPathComponent("Checklist.plist")
    }
}
