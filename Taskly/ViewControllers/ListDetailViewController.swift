//
//  ListDetailViewController.swift
//  Taskly
//
//  Created by Celil Çağatay Gedik on 10.11.2022.
//

import UIKit

// Any object that conforms to this protocol must implement these two methods.
protocol ListDetailViewControllerDelegate: AnyObject {
    
    // This method is for when the user presses the Cancel.
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    
    // This method is for when the user press Done.
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding item: TasklyGroup)
    
    // This method is for editing.
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing item: TasklyGroup)
}


class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImage: UIImageView!
    
    var iconName = "Folder"
    weak var delegate: ListDetailViewControllerDelegate?
    var tasklyGroupToEdit: TasklyGroup?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tasklyGroup = tasklyGroupToEdit {
            title = "Edit Taskly📝 Group"
            textField.text = tasklyGroup.name
            doneBarButton.isEnabled = true
            
            iconName = tasklyGroup.iconName
        }
        iconImage.image = UIImage(named: iconName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Pop-up keyboard.
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Icon Picker View Controller Delegate
    
    // This puts the name of the chosen icon into the iconName variable to remember it, and also updates the image view with the new image.
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        iconImage.image = UIImage(named: iconName)
        
        // After all we do that, we use popViewController to "pop" the IconPickerViewController off the navigation stack.
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
    
    //MARK: - Actions
    
    @IBAction func cancel() {
        
        // When user taps the Cancel button, you send the itemDetailViewControllerDidCancel(_:) message back to delegate.
        delegate?.listDetailViewControllerDidCancel(self)
        // "?" tells swift not to send the message if delegate is nil.
    }
    
    @IBAction func done() {
        
        /*
         FOR EDITING THE ITEM
         */
        
        // This line checks whether the tasklyGroupToEdit property contains an object.
        if let tasklyGroup = tasklyGroupToEdit {
            
            // If the optional is not nil, we put the text from the text field into the existing TasklyItem object and then call the new delegate method.
            tasklyGroup.name = textField.text!
            
            // It puts chosen icon name into TasklyGroup object when the user closes the screen.
            tasklyGroup.iconName = iconName
            
            delegate?.listDetailViewController(self, didFinishEditing: tasklyGroup)
            
            /*
             FOR ADDING THE NEW ITEM
             */
        } else {
            
            // This method puts new textField and iconName into the TasklyGroup.
            let tasklyGroup = TasklyGroup(name: textField.text!, iconName: iconName)
                        
            // When user taps the Done button, you send the itemDetailViewController(_:didFinishAdding:) message new TasklyGroup object that has the new text string from the text field.
            delegate?.listDetailViewController(self, didFinishAdding: tasklyGroup)
            // "?" tells swift not to send the message if delegate is nil.
        }
    }
    
    // MARK: - Table View Delegates
    
    // With this change you can tao the "Image" cell to trigger the segue.
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 1 ? indexPath : nil
    }
    
    // MARK: - Text Field Delegate
    
    // It gives us which part of the text should replaced with our new-writed text.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // We should calculate what the new text will be by taking the text field's text and doing the replacement yourself.
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        
        // It gives us a new string object that we store in the newText constant.
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        //If text field is empty disable the done button
        if newText.isEmpty {
            doneBarButton.isEnabled = false
            
            // If text field is filled,enable the done button.
        } else {
            doneBarButton.isEnabled = true
        }
        return true
    }
    
    // When we pressed the clear button in text field, the done button was not disabled. This code is a solution for it.
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}

