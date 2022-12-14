//
//  AllListsViewController.swift
//  Taskly
//
//  Created by Celil Çağatay Gedik on 10.11.2022.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    // Instead of its own array, the AllListsViewController now uses this DataModel object, which it accesses through the dataModel property.
    var dataModel: DataModel!
    
    let cellIdentifier = "TasklyGroupCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // Showing the last opened list. When we back to the app.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // First, view controller makes itself delegate for the navigation controller.
        navigationController?.delegate = self
        
        // Then we checking the dataModel to see whether it has perform the segue.
        let index = dataModel.indexOfSelectedTaskly
        
        // Lastly, we checking & determine whether if the index is valid and value setting is -0 or above, then the user was on the app's TasklyGroup screen before the app was terminated.
        if index >= 0 && index < dataModel.lists.count {
            let taskly = dataModel.lists[index]
            performSegue(withIdentifier: "ShowTasks", sender: taskly)
        }
    }

    // MARK: - List Detail View Controller Delegates
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding taskly: TasklyGroup) {
        
        dataModel.lists.append(taskly)
        dataModel.sortTasklyGroups()
        tableView.reloadData()
        
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing taskly: TasklyGroup) {
        
        dataModel.sortTasklyGroups()
        tableView.reloadData()
        
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // We define a constant to hold the newly created cell.
        let cell: UITableViewCell!
        
        // Then see we can dequeue a cell from table view for the given identifier.
        if let tmp = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            
            // If there is a cell, then we assign it reference to the previously declared constant.
            cell = tmp
        
        // If there is no cell, then we create a new UITableViewCell instance with cell style.
        } else {
          cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let taskly = dataModel.lists[indexPath.row]
        cell.textLabel!.text = taskly.name
        cell.accessoryType = .detailDisclosureButton
        
        // This code shows how subtitle cell will look in different conditions.
        let count = taskly.countUncheckedItems()
        if taskly.items.count == 0 {
            cell.detailTextLabel!.text = "No Items"
        } else {
            cell.detailTextLabel!.text = count == 0 ? "All done" : "\(count) Remaining."
        }
        
        // Putting icon into the tabel view cell.(TasklyGroup)
        cell.imageView!.image = UIImage(named: taskly.iconName)
        return cell
    }
    
    // MARK: - Table View Delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // We storing the index of the selected row into UserDefaults under by the dataModel.
        dataModel.indexOfSelectedTaskly = indexPath.row
        
        // We don't have prototype cell hooked up with segue. Because our table view for this screen isn't using prototype cell. Therefore, we doing this manualy.
        let taskly = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowTasks", sender: taskly)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    // This method for Add/Edit TasklyGroup.
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        
        let tasklyGroup = dataModel.lists[indexPath.row]
        controller.tasklyGroupToEdit = tasklyGroup
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowTasks" {
            let controller = segue.destination as! TasklyViewController
            controller.taskly = sender as? TasklyGroup
            
        } else if segue.identifier == "AddTasklyGroup" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    // MARK: - Navigation Controller Delegates
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
       
        // If the back button was pressed, the new view controller is AllListsViewController itself and you set the "SelectedTaskly” value in UserDefaults to -1, meaning that no TasklyGroup is currently selected.
        if viewController === self {
            dataModel.indexOfSelectedTaskly = -1
        }
    }
    
    /*
     "===" means we are checking whether two variable refer to exact same object.
     "==" means we are checking whether two variable have the same value.
     */
}

