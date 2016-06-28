//
//  IconPickerViewController.swift
//  CheckList
//
//  Created by kemchenj on 5/16/16.
//  Copyright © 2016 kemchenj. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate : class {
    func iconPicker(_ picker: IconPickerViewController, didPickIcon iconName: String)
}

class IconPickerViewController: UITableViewController {
    weak var delegate: IconPickerViewControllerDelegate?
    
    let icons = [ "No Icon",
                  "Appointments",
                  "Birthdays",
                  "Chores",
                  "Drinks",
                  "Folder",
                  "Groceries",
                  "Inbox",
                  "Photos",
                  "Trips"
    ]
    
    
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            let iconName = icons[(indexPath as NSIndexPath).row]
            delegate.iconPicker(self, didPickIcon: iconName)
        }
    }
    
    
    
    // MARK: - TableView DataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        
        let iconName = icons[(indexPath as NSIndexPath).row]
        cell.textLabel!.text  = iconName
        cell.imageView!.image = UIImage(named: iconName)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
}
