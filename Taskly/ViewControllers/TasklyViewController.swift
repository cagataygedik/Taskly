//
//  ViewController.swift
//  Taskly
//
//  Created by Celil Çağatay Gedik on 2.11.2022.
//

import UIKit

class TasklyViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    // Empty array
    var items = [TasklyItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Displays large title.
        navigationController?.navigationBar.prefersLargeTitles = true
        
       // Adding items at the array
        let item1 = TasklyItem()
        item1.text = "deneme1"
        items.append(item1)
        
        let item2 = TasklyItem()
        item2.text = "deneme2deneme2"
        item2.checked = true
        items.append(item2)
        
        let item3 = TasklyItem()
        item3.text = "deneme3deneme3deneme3"
        item3.checked = true
        items.append(item3)
        
        let item4 = TasklyItem()
        item4.text = "hello guyss"
        items.append(item4)
        
        let item5 = TasklyItem()
        item5.text = "turkish delight"
        items.append(item5)
      
        
    }
    
    // MARK: - Add Item ViewController Delegates
    
    // This function closes the AddItemScreen.
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    // This function closes too AddItemScreen.
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: TasklyItem) {
        
        let newRowIndex = items.count
        items.append(item)
        
        // We have to tell the table view about this new row so it can add a new cell for that row.
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        
        let indexPaths = [indexPath]
        
        // We have to tell the table view to insert this new row.
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: TasklyItem) {
        
        // We can use the firstIndex(of:) method to return the index of the first item from the array which matches the passed in TasklyItem.
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the actual number of items
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasklyItem", for: indexPath)
        
        // Once you have that object, you can simply look at its text and checked properties and do whatever you need to do.
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    // MARK: - Table View Delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
            // Once you have that object, you can simply look at its text and checked properties and do whatever you need to do.
            let item = items[indexPath.row]
            
            item.checked.toggle()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Swipe to delete function
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    // MARK: - Actions
    
    // Toggle the checkmark
    func configureCheckmark(for cell: UITableViewCell, with item: TasklyItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "✅"
        } else {
            label.text = ""
        }
       
    }
    
    // This is for configuring the text.
    func configureText(for cell: UITableViewCell, with item: TasklyItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    // MARK: - Navigation
    
    // An object that prepares for and performs the visual transition between two view controllers.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Checking if we handling the correct segue.
        if segue.identifier == "AddItem" {
            
            // We cast destination to AddItemViewController to get a reference to an object with the right type.
            let controller = segue.destination as! ItemDetailViewController
            
            //Once we have a reference to the AddItemViewController object, you set its delegate property to self and the connection is complete. This tells AddItemViewController that from now on, the object identified as self is its delegate.
            controller.delegate = self
            
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            
            // We use that UITableViewCell object to find the table view row number by looking up the corresponding index path using tableView.indexPath(for:).
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                
                // We have the index path, you obtain the TasklyItem object to edit, and you assign this to AddItemViewController’s itemToEdit property.
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
}
