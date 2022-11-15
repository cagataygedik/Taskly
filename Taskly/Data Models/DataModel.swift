//
//  DataModel.swift
//  Taskly
//
//  Created by Celil Çağatay Gedik on 13.11.2022.
//

import Foundation

class DataModel {
    var lists = [TasklyGroup]()
    
    init() {
        loadTasklyGroups()
        registerDefaults()
        handleFirstTime()
    }
    
    // Returns the full path to the Documents folder.
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // This method uses documentsDirectory() to construct the full path to the file that will store the checklist items.
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Taskly.plist")
    }
    
    func saveTasklyGroups() {
        
        // We create an instance of PropertyListEncoder which will encode the "list" array, and all the "TasklyGroup"'s in it.
        let encoder = PropertyListEncoder()
        
        // Sets up a block of code to catch the errors.
        do {
            
            // We're trying the encode lists.
            let data = try encoder.encode(lists)
            
            // We're writing the data to a file using dataFilePath().
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
            
            // This statement indicates the block of code to be executed if an error was thrown by any line of code in the do block.
        } catch {
            print("Error encoding list array: \(error.localizedDescription)")
            
        }
    }
    
    func loadTasklyGroups() {
        
        // We put results of dataFilePath() in a temporary constant named path.
        let path = dataFilePath()
        
        // Try to load the contents of Checklist.plist into a new Data object.
        if let data = try? Data(contentsOf: path) {
            
            // When app find a Checklist.plist file we'll load the entire array and its contents from the file using a PropertyListDecoder().
            let decoder = PropertyListDecoder()
            
            // Sets up a block of code to catch the errors.
            do {
                // Load the saved data back into lists using the decoder’s decode method. The decoder needs to know what type of data will be the result of the decode operation and we let it know by indicating that it will be an array of TasklyGroup objects.
                lists = try decoder.decode([TasklyGroup].self, from: data)
                
                // We are making existing lists are also sorted in right order
                sortTasklyGroups()
                
                // This statement indicates the block of code to be executed if an error was thrown by any line of code in the do block.
            } catch {
                print("Error decoding list array: \(error.localizedDescription)")
            }
        }
    }
    
    // This creates a anew Dictionary instance and adds the value -1 for the key "TasklyIndex".
    func registerDefaults() {
        let dictionary = [ "TasklyIndex" : -1, "FirstTime" : true ] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    // UserDefaults will use the values from this dictionary if you ask it for a key and it cannot find values for that key.
    
    var indexOfSelectedTaskly: Int {
        
        // This for when the app tries to read value of indexOfSelectedTaskly.
        get {
            return UserDefaults.standard.integer(forKey: "TasklyIndex")
        }
        
        // This for when the app tries to put a new value into indexOfSelectedTaskly.
        set {
            UserDefaults.standard.set(newValue, forKey: "TasklyIndex")
        }
    }
    
    // This method is for first time launching the app.
     func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let taskly = TasklyGroup(name: "Add Your Tasks Here!")
            lists.append(taskly)
            
            indexOfSelectedTaskly = 0
            userDefaults.set(false, forKey: "FirstTime")
        }
    }
    
    // This method is for sorting the TasklyGroups alphabetically.
    func sortTasklyGroups() {
        lists.sort { list1, list2 in
            return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        }
    }
}
