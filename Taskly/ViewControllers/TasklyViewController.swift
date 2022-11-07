//
//  ViewController.swift
//  Taskly
//
//  Created by Celil Çağatay Gedik on 2.11.2022.
//

import UIKit

class TasklyViewController: UITableViewController, AddItemViewControllerDelegate {
    
    // Empty array
    var items = [TasklyItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Displays large title.
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Adding items at the array
        let item1 = TasklyItem()
        item1.text = "Walk the dog"
        items.append(item1)
        
        let item2 = TasklyItem()
        item2.text = "Brush my teeth"
        item2.checked = true
        items.append(item2)
        
        let item3 = TasklyItem()
        item3.text = "Learn iOS development"
        item3.checked = true
        items.append(item3)
        
        let item4 = TasklyItem()
        item4.text = "Soccer practice"
        items.append(item4)
        
        let item5 = TasklyItem()
        item5.text = "Eat ice cream"
        items.append(item5)
        
    }
    
    // MARK: - Add Item ViewController Delegates
    
    // This function closes the AddItemScreen.
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    // This function closes too AddItemScreen.
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: TasklyItem) {
        
        let newRowIndex = items.count
        items.append(item)
        
        // We have to tell the table view about this new row so it can add a new cell for that row.
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        
        let indexPaths = [indexPath]
        
        // We have to tell the table view to insert this new row.
        tableView.insertRows(at: indexPaths, with: .automatic)
        
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
        
        if item.checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    // I still don't fucking understand why I write that
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
            let controller = segue.destination as! AddItemViewController
            
            //Once we have a reference to the AddItemViewController object, you set its delegate property to self and the connection is complete. This tells AddItemViewController that from now on, the object identified as self is its delegate.
            controller.delegate = self
            
        }
    }
}
