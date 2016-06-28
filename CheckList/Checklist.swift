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
        // var count = 0
        // for item in items where !item.checked {
        //     count += 1
        // }
        
        // return count
        
        
        return items.reduce(0) { cnt, item in cnt + (item.checked ? 0 : 1) }
        // cnt是参数的名字, 也就是0, 可以随意更改
        // item in items
        // cnt + (item.checked ? 0 : 1)
    }
    
    func sortItemsWithDueDate() {
        items.sort(isOrderedBefore: { item1, item2 in return item1.dueDate.compare(item2.dueDate as Date) == .orderedAscending })
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
