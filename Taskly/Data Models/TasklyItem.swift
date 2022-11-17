//
//  TaskylItem.swift
//  Taskly
//
//  Created by Celil Çağatay Gedik on 3.11.2022.
//

import Foundation
import UserNotifications

class TasklyItem : NSObject, Codable{
    
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1
    
    // This asks the DataModel object for a new item ID whenever the app creates a new TasklyItem object and replaces the initial value of -1 with that unique ID.
    override init() {
        super.init()
        itemID = DataModel.nextTasklyItemID()
    }
    
    init(text: String, checked: Bool = false) {
        self.text = text
        self.checked = checked
        super.init()
    }
    
    deinit {
        removeNotification()
    }
    
    // MARK: - Notification Functions
    
    // This method compares the due date on the item with the current date.
    func scheduleNotification() {
        
        removeNotification()
        
        if shouldRemind && !checked && dueDate > Date() {
            
            // Put the item's text into notification message.
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default
            
            // Extracting the components from dueDate.
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
            
            // Shows the notification at specified date.
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            // Creates a request object. We are converting the item's numeric ID into a String for identify the notification.
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
            // Adding the new notification to the UNUSerNotificationCenter.
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
    
}
