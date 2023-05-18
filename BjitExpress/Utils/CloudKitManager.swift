//
//  CloudKitManager.swift
//  BjitExpress
//
//  Created by YeasirArefinTusher-11702 on 18/5/23.
//

import Foundation
import CloudKit
class CloudKitManager {
    static let shared = CloudKitManager()
    private let container: CKContainer
    private let publicDatabase: CKDatabase
    
    private init() {
        container = CKContainer(identifier: "iCloud.TeamCombine.bjitgroup.upskilldev")
        publicDatabase = container.publicCloudDatabase
    }
    
    // MARK: - CRUD Operations
    
    //TODO:  Create a record
    
    
    // Fetch records with a predicate
    func fetchRecords(predicate: NSPredicate, completion: @escaping (Result<[CKRecord], Error>) -> Void) {
        let query = CKQuery(recordType: "User", predicate: predicate)
        
        publicDatabase.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                completion(.failure(error))
            } else if let records = records {
                completion(.success(records))
            }
        }
    }
    
    // Update a record
    func updateRecord(recordId: CKRecord.ID, value: String) {
        publicDatabase.fetch(withRecordID: recordId) { record, err in
            
            
            if let fetchedRecord = record{
                // Modify the record
                fetchedRecord["password"] = value as CKRecordValue
                self.publicDatabase.save(fetchedRecord) { (savedRecord, error) in
                if let error = error {
                    print("Error saving record: \(error)")
                } else {
                    print("Record saved successfully")
                }
            }
        } else if let error = err {
            print("Error fetching record: \(error)")
        }
            
    }
}

// //TODO:  Deleted

}
