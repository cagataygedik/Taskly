//
//  AddItemViewController.swift
//  Taskly
//
//  Created by Celil Çağatay Gedik on 4.11.2022.
//

import UIKit

// Any object that conforms to this protocol must implement these two methods.
protocol ItemDetailViewControllerDelegate: AnyObject {
    
    // This method is for when the user presses the Cancel.
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    
    // This method is for when the user press Done.
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: TasklyItem)
    
    // This method is for editing.
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: TasklyItem)
}


class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: TasklyItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
    }
    
    // Keyboard automatically shows up when we navigate to the screen.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    @IBAction func cancel() {
        
        // When user taps the Cancel button, you send the itemDetailViewControllerDidCancel(_:) message back to delegate.
        delegate?.itemDetailViewControllerDidCancel(self)
        // "?" tells swift not to send the message if delegate is nil.
    }
    
    @IBAction func done() {
        
        /*
         FOR EDITING THE ITEM
         */
        
        // This line checks whether the itemToEdit property contains an object.
        if let item = itemToEdit {
            
            // If the optional is not nil, we put the text from the text field into the existing TasklyItem object and then call the new delegate method.
            item.text = textField.text!
            
            delegate?.itemDetailViewController(self, didFinishEditing: item)
            
            /*
             FOR ADDING THE NEW ITEM
             */
        } else {
            let item = TasklyItem()
            item.text = textField.text!
            
            // When user taps the Done button, you send the itemDetailViewController(_:didFinishAdding:) message new TasklyItem object that has the new text string from the text field.
            delegate?.itemDetailViewController(self, didFinishAdding: item)
            // "?" tells swift not to send the message if delegate is nil.
        }
    }
    
    // MARK: - Table View Delegates
    
    // Disabled cell selection in text field.
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    // MARK: - Text Field Delegates
    
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
