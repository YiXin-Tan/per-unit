//
//  DatabaseController.swift
//  per-unit
//
//  Created by yixin on 09/10/2025.
//

import Foundation
import CoreData

// @State controller: DataController
// created when our app starts and stays
class DataController: ObservableObject {
    var container = NSPersistentContainer(name: "PerUnit") // references the data model schema
    
    init(){
        container
            .loadPersistentStores(completionHandler: {description, error in
                if let error = error {
                    print("Error loading Bookwork data model: \(error.localizedDescription)")
                }
                
                self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            })
    }
}
