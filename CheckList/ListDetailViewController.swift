//
//  ListDetailViewController.swift
//  CheckList
//
//  Created by kemchenj on 5/2/16.
//  Copyright © 2016 kemchenj. All rights reserved.
//

import UIKit



// MARK: - Delegate Protocol

protocol ListDetailViewControllerDelegate: class {
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAddingChecklist checklist: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditingChecklist checklist: Checklist)
    
}



// MARK: - Class

class ListDetailViewController: UITableViewController{
    
    var iconName = "Folder"
    var checklistToEdit: Checklist?
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImageView: UIImageView!
    
}



// MARK: - UIView
    
extension ListDetailViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
            iconName = checklist.iconName
        }
        
        iconImageView.image = UIImage.init(named: iconName)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }

}



// MARK: - Buttons

private extension ListDetailViewController {
    
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }

    @IBAction func done() {
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            checklist.iconName = iconName
            
            delegate?.listDetailViewController(self, didFinishEditingChecklist: checklist)
        } else {
            let checklist = Checklist(name: textField.text!, iconName:iconName)
            delegate?.listDetailViewController(self, didFinishAddingChecklist: checklist)
        }
        
        NSLog("test")
    }
    
}



// MARK: - IconPickerView Delegate

extension ListDetailViewController: IconPickerViewControllerDelegate {
    
    func iconPicker(_ picker: IconPickerViewController, didPickIcon iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage.init(named: iconName)
        navigationController!.popViewController(animated: true)
    }
    
}



// MARK: - Segue

extension ListDetailViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }

}



// MARK: - TableView Delegate

extension ListDetailViewController {
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (indexPath ).section == 1 {
            return indexPath
        } else {
            return nil;
        }
    }
    
}


    
// MARK: - TextField Delegate

extension ListDetailViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString

        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
    
}
