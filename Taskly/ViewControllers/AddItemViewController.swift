//
//  AddItemViewController.swift
//  Taskly
//
//  Created by Celil Çağatay Gedik on 4.11.2022.
//

import UIKit

class AddItemViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    // MARK: - Actions
    
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done() {
        navigationController?.popViewController(animated: true)
    }
    
}
