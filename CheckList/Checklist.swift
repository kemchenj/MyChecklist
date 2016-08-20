//
//  Checklist.swift
//  CheckList
//
//  Created by kemchenj on 4/19/16.
//  Copyright © 2016 kemchenj. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding
{
    var name  = ""
    var items = [ChecklistItem]()
    var iconName: String
    
    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
    
    init(name: String, iconName: String) {
        self.name     = name
        self.iconName = iconName
        super.init()
    }
    
    func countUncheckedItems() -> Int{
        return items.reduce(0) { cnt, item in cnt + (item.checked ? 0 : 1) }
    }
    
    func sortItemsWithDueDate() {
        items.sort(by: { $0.dueDate.compare($1.dueDate as Date) == .orderedAscending })
    }
    
    
    
    // MARK: - NSCoding Protocol
    
    required init?(coder aDecoder: NSCoder) {
        name     = aDecoder.decodeObject(forKey: "Name") as! String
        items    = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObject(forKey: "IconName") as! String
    }

    func encode(with aDecoder: NSCoder) {
        aDecoder.encode(name, forKey: "Name")
        aDecoder.encode(items, forKey: "Items")
        aDecoder.encode(iconName, forKey: "IconName")
    }
    
}
