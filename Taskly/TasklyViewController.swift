//
//  ViewController.swift
//  Taskly
//
//  Created by Celil Çağatay Gedik on 2.11.2022.
//

import UIKit

class TasklyViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasklyItem", for: indexPath)
        return cell
    }

}

