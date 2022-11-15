//
//  TaskylItem.swift
//  Taskly
//
//  Created by Celil Çağatay Gedik on 3.11.2022.
//

import Foundation

class TasklyItem : NSObject, Codable{
    
    var text = ""
    var checked = false
    
    init(text: String, checked: Bool = false) {
        self.text = text
        self.checked = checked
        super.init()
    }
}
