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
    
    // This method asks TasklyGroup object how many of its TasklyItem objects are still not checked.
    func countUncheckedItems() -> Int {
        var count = 0
        
        // Where not item.checked"
        for item in items where !item.checked {
            count += 1
        }
        // When the loop is over we return total value of the count.
        return count
    }
    
}
