//
//  CloudKitViewModel.swift
//  BjitExpress
//
//  Created by Md. Mominul Islam on 16/5/23.
//

import Foundation
import CloudKit
import Combine

protocol CloudKitableProtocol {
    init?(record: CKRecord)
    var record: CKRecord { get }
}

class CloudKitViewModel {

    static let ckContainer = CKContainer(identifier: Constant.cloudKitContainerName)

    enum CloudKitError: String, LocalizedError {
        case iCloudAccountNotFound
        case iCloudAccountNotDetermined
        case iCloudAccountRestricted
        case iCloudAccountUnknown
        case iCloudApplicationPermissionNotGranted
        case iCloudCouldNotFetchUserRecordID
        case iCloudCouldNotDiscoverUser
    }

    static private func getiCloudStatus(completion: @escaping (Result<Bool, Error>) -> ()) {
        CKContainer.default().accountStatus { returnedStatus, returnedError in
            switch returnedStatus {
            case .available:
                completion(.success(true))
            case .noAccount:
                completion(.failure(CloudKitError.iCloudAccountNotFound))
            case .couldNotDetermine:
                completion(.failure(CloudKitError.iCloudAccountNotDetermined))
            case .restricted:
                completion(.failure(CloudKitError.iCloudAccountRestricted))
            default:
                completion(.failure(CloudKitError.iCloudAccountUnknown))
            }
        }
    }

    static func getiCloudStatus() -> Future<Bool, Error> {
        Future { promise in
            CloudKitViewModel.getiCloudStatus { result in
                promise(result)
            }
        }
    }

    static private func requestApplicationPermission(completion: @escaping (Result<Bool, Error>) -> ()) {
        CKContainer.default().requestApplicationPermission([.userDiscoverability]) { returnedStatus, returnedError in
            if returnedStatus == .granted {
                completion(.success(true))
            } else {
                completion(.failure(CloudKitError.iCloudApplicationPermissionNotGranted))
            }
        }
    }

    static func requestApplicationPermission() -> Future<Bool, Error> {
        Future { promise in
            CloudKitViewModel.requestApplicationPermission { result in
                promise(result)
            }
        }
    }

    static func fetch<T: CloudKitableProtocol>(
        predicate: NSPredicate,
        recordType: CKRecord.RecordType,
        sortDescriptions: [NSSortDescriptor]? = nil,
        resultsLimit: Int? = nil
    ) -> Future<[T], Error> {
        Future { promise in
            CloudKitViewModel.fetch(predicate: predicate, recordType: recordType, sortDescriptions: sortDescriptions, resultLimit: resultsLimit) { (items: [T]) in
                promise(.success(items))
            }
        }
    }

    static private func fetch<T: CloudKitableProtocol> (
        predicate: NSPredicate,
        recordType: CKRecord.RecordType,
        sortDescriptions: [NSSortDescriptor]? = nil,
        resultLimit: Int? = nil,
        completion: @escaping(_ items: [T]) -> ()) {
        
    }

    static private func createOperation(
        predicate: NSPredicate,
        recordType: CKRecord.RecordType,
        sortDescriptions: [NSSortDescriptor]? = nil,
        resultLimit: Int? = nil
    ) -> CKQueryOperation {
        let query: CKQuery = CKQuery(recordType: recordType, predicate: predicate)
        let queryOperation: CKQueryOperation = CKQueryOperation(query: query)
        if let limit = resultLimit {
            queryOperation.resultsLimit = limit
        }
        return queryOperation
    }

    static private func addRecordMatchedblock<T:CloudKitableProtocol>(
        opertation: CKQueryOperation,
        completion: @escaping(_ item: T) -> ()) {
        opertation.recordMatchedBlock = { (recordId, recordResult) in
            switch recordResult {
            case .success(let record):
                guard let item = T(record: record) else { return }
                completion(item)
            case .failure(_):
                break
            }
        }
    }

    static private func addQueryResultBlock(
        opertation: CKQueryOperation,
        completion: @escaping(_ isFinished: Bool) -> ()
    ) {
        opertation.queryResultBlock = { (resultCoursor) in
            completion(true)
        }
    }

    static private func addOperation(opertation: CKQueryOperation) {
        CloudKitViewModel.ckContainer.publicCloudDatabase.add(opertation)
    }

    static func add<T:CloudKitableProtocol>(item: T, completion: @escaping (Result<Bool, Error>) -> ()) {
        let record = item.record
        save(record: record, completion: completion)
    }
    
    static func update<T:CloudKitableProtocol>(item: T, completion: @escaping (Result<Bool, Error>) -> ()) {
        add(item: item, completion: completion)
    }
    
    static private func save(record: CKRecord, completion: @escaping (Result<Bool, Error>) -> ()) {
        CKContainer.default().publicCloudDatabase.save(record) { returnedRecord, returnedError in
            if let error = returnedError {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    static func delete<T:CloudKitableProtocol>(item: T) -> Future<Bool, Error> {
        Future { promise in
            CloudKitViewModel.delete(item: item, completion: promise)
        }
    }
    
    static private func delete<T:CloudKitableProtocol>(item: T, completion: @escaping (Result<Bool, Error>) -> ()) {
        CloudKitViewModel.delete(record: item.record, completion: completion)
    }
    
    static private func delete(record: CKRecord, completion: @escaping (Result<Bool, Error>) -> ()) {
        CKContainer.default().publicCloudDatabase.delete(withRecordID: record.recordID) { returnedRecordID, returnedError in
            if let error = returnedError {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
}
