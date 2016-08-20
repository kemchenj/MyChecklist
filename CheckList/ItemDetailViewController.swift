//
//  ItemDetailViewController.swift
//  CheckList
//
//  Created by kemchenj on 4/17/16.
//  Copyright © 2016 kemchenj. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications



// MARK: - Delegate Protocol

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditItem item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
}



// MARK: - Class

class ItemDetailViewController: UITableViewController {
    
    var itemToEdit: ChecklistItem?
    var dueDate = Date()
    var datePickerVisible = false
    
    weak var delegate: ItemDetailViewControllerDelegate?

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerCell: UITableViewCell!
}



// MARK: - Notification

extension ItemDetailViewController: Hudable {
    
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        textField.resignFirstResponder()
        
        if switchControl.isOn {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert], completionHandler: { [weak self] (granded, error) in
                guard let strongSelf = self else { fatalError() }
                
                if let error = error {
                    strongSelf.showHudInView(text: "\(error)", rootView: strongSelf.view, animated: true)
                }
            })
        }
    }
}



// MARK: - DateLabel Thing

private extension ItemDetailViewController {
    
    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    
    func showDatePicker() {
        datePickerVisible = true
        
        let indexPathDateRow = IndexPath(row: 1, section: 1)
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        
        if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel?.tintColor
        }
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.endUpdates()
        
        datePicker.setDate(dueDate, animated: false)
    }
    
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            
            let indexPathDateRow = IndexPath(row: 1, section: 1)
            let indexPathDatePicker = IndexPath(row: 2, section: 1)
            
            if let cell = tableView.cellForRow(at: indexPathDateRow) {
                cell.detailTextLabel?.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            tableView.beginUpdates()
            
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
            
            tableView.endUpdates()
        }
    }
}



// MARK: - Button (Navigation Bar)

private extension ItemDetailViewController {

    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }

    @IBAction func done() {
        if let item = itemToEdit {
            item.text         = textField.text!
            item.dueDate      = dueDate
            item.shouldRemind = shouldRemindSwitch.isOn
            item.scheduleNotification()
            
            delegate?.itemDetailViewController(self, didFinishEditItem: item)
            // Optional: if delegate == nil, the sentence after "?" would not be executed
        } else {
            let item = ChecklistItem()
            item.text         = textField.text!
            item.dueDate      = dueDate
            item.shouldRemind = shouldRemindSwitch.isOn
            item.scheduleNotification()
            
            delegate?.itemDetailViewController(self, didFinishAddingItem: item)
        }
    }

    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
}



// MARK: - View Lifecyle

extension ItemDetailViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text        = item.text
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate as Date
        }
                
        updateDueDateLabel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
        // 让textField成为第一个响应的object
        // 在storyboard里把textField的return key设置为done的话, 虚拟键盘按return也会触发done
    }
}



// MARK: - TableView
// MARK: + Delegate

extension ItemDetailViewController {
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (indexPath ).section == 1 && (indexPath ).row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath ).section == 1 && (indexPath ).row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        textField.resignFirstResponder()
        
        if (indexPath ).section == 1 && (indexPath ).row == 1 {
            if datePickerVisible {
                hideDatePicker()
            } else {
                showDatePicker()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var tempPath = indexPath
        
        if (indexPath ).section == 1 && (indexPath ).row == 2 {
            tempPath = IndexPath(row: 0, section: (indexPath ).section)
        }
        
        return super.tableView(tableView, indentationLevelForRowAt:tempPath)
    }
    
}



// MARK: + DataSource

extension ItemDetailViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath ).section == 1 && (indexPath ).row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
}



// MARK: - TextField Delegate

extension ItemDetailViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString

        doneBarButton.isEnabled = (newText.length > 0)

        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    
}
