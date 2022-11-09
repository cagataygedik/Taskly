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
        
        // Load items.
        loadChecklistItems()
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
        
        saveChecklistItems()
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
        
        saveChecklistItems()
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
            
            saveChecklistItems()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Swipe to delete function
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
        saveChecklistItems()
    }
    
    // MARK: - Actions
    
    // Toggle the checkmark
    func configureCheckmark(for cell: UITableViewCell, with item: TasklyItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "✅"
        } else {
            label.text = "☑️"
        }
    }
    
    // This is for configuring the text.
    func configureText(for cell: UITableViewCell, with item: TasklyItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    // Returns the full path to the Documents folder.
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // This method uses documentsDirectory() to construct the full path to the file that will store the checklist items.
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklist.plist")
    }
    
    func saveChecklistItems() {
        
        // We create an instance of PropertyListEncoder which will encode the "items" array, and all the "TasklyItem"'s in it.
        let encoder = PropertyListEncoder()
        
        // Sets up a block of code to catch the errors.
        do {
            
            // We're trying the encode items.
            let data = try encoder.encode(items)
            
            // We're writing the data to a file using dataFilePath().
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
            
            // This statement indicates the block of code to be executed if an error was thrown by any line of code in the do block.
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
            
        }
    }
    
    func loadChecklistItems() {
        
        // We put results of dataFilePath() in a temporary constant named path.
        let path = dataFilePath()
        
        // Try to load the contents of Checklist.plist into a new Data object.
        if let data = try? Data(contentsOf: path) {
            
            // When app find a Checklist.plist file we'll load the entire array and its contents from the file using a PropertyListDecoder().
            let decoder = PropertyListDecoder()
            
            // Sets up a block of code to catch the errors.
            do {
                // Load the saved data back into items using the decoder’s decode method. The decoder needs to know what type of data will be the result of the decode operation and we let it know by indicating that it will be an array of TasklyItem objects.
                items = try decoder.decode([TasklyItem].self, from: data)
             
            // This statement indicates the block of code to be executed if an error was thrown by any line of code in the do block.
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
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
