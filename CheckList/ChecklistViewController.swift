//
//  ViewController.swift
//  CheckList
//
//  Created by kemchenj on 4/16/16.
//  Copyright © 2016 kemchenj. All rights reserved.
//

import UIKit



class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate
{
    var checklist: Checklist!
    



    // MARK: - UIView

    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
    }
    
    
    
    // MARK: - Segue
    
    // 通知view某个segue将要触发了
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1. 因为代理可能不止一个，所以需要用identifier来判断是否是自己需要的那个代理
        // swift的==可以用在绝大部分数据类型上，例如string等
        if segue.identifier == "AddItem" {
            // 2. 从storyboard可以看到ChecklistViewController并不直接连AddItemViewController，中间隔着navigationBar，所以需要先获取navigationBar
            let navigationController = segue.destination as! UINavigationController
            navigationController.title = "Add Item"
            let controller = navigationController.topViewController as! ItemDetailViewController
            // 3. 把AddItemViewController的代理设置为ChecklistViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            navigationController.title = "Edit Item"
            controller.delegate = self
            // 函数定义的参数列表里有any Object的话，在调用的时候就需要指定该参数的类型
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[(indexPath ).row]
            }
        }
    }

    
    
    // MARK: - Configure Content
    
    func configureCheckmarkForCell(_ cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel

        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }

    func configureTextForCell(_ cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }

    

    // MARK: - ItemDetailViewController Delegate
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }

    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        let newRowIndex = checklist.items.count

        checklist.items.append(item)
        // add the new item to the items(Model)

        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        // call view to refresh
        // 通知view在哪个section的哪个index插入了row
        // 然后view会自动跟controller索取数据去填充那些rows

        dismiss(animated: true, completion: nil)
    }

    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditItem item: ChecklistItem) {
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureTextForCell(cell, withChecklistItem: item)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - TableView

    // view ask for data
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)

        let item = checklist.items[(indexPath ).row]

        configureTextForCell(cell, withChecklistItem: item)
        configureCheckmarkForCell(cell, withChecklistItem: item)
        return cell
    }

    // check or uncheck
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[(indexPath ).row]
            item.toggleChecked()
            
            configureCheckmarkForCell(cell, withChecklistItem: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // 1. Remove the item from the data model
        checklist.items.remove(at: (indexPath ).row)
        // 2. Delete the corresponding row from the table view
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }

}

