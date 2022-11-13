//
//  Taskly.swift
//  Taskly
//
//  Created by Celil Çağatay Gedik on 10.11.2022.
//

import UIKit

class TasklyGroup: NSObject, Codable {

    var name = ""
    
    // This creates a new empty array that can hold TasklyItem objects and assigns it to the items property.
    var items = [TasklyItem]()
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
}
