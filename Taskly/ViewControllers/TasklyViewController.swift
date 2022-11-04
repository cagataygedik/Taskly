//
//  ViewController.swift
//  Taskly
//
//  Created by Celil Çağatay Gedik on 2.11.2022.
//

import UIKit

class TasklyViewController: UITableViewController {
    
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
    
    // Creates a new TasklyItem object and adds it to the data model.
    @IBAction func addItem() {
        let newRowIndex = items.count
        
        // It creates a new TasklyItem object and adds it to the end of the array.
        let item = TasklyItem()
        item.text = "I am a new row"
        items.append(item)
        
        // We have to tell the table view about this new row so it can add a new cell for that row.
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        
        let indexPaths = [indexPath]
        
        // We have to tell the table view to insert this new row.
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
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
}
