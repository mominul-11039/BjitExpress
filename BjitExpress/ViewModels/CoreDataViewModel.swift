//
//  CoreDataViewModel.swift
//  BjitExpress
//
//  Created by Md. Mominul Islam on 16/5/23.
//

import Foundation
import CoreData

class CoreDataViewModel {

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: Constant.coreDataContainerName)
        container.loadPersistentStores { storeDesc, error in
            if let error = error {
                print("Core Data error : \(error)")
            }
        }
    }

    func saveData() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving. \(error)")
        }
    }

}
