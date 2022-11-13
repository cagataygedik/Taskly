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
                 
                // This statement indicates the block of code to be executed if an error was thrown by any line of code in the do block.
                } catch {
                    print("Error decoding list array: \(error.localizedDescription)")
                }
            }
        }
}
