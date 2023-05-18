//
//  LoginViewModel.swift
//  BjitExpress
//
//  Created by YeasirArefinTusher-11702 on 18/5/23.
//

import Foundation
import SwiftUI
import CloudKit

class LoginViewModel : ObservableObject{
    
    private var currentRecordID: CKRecord.ID?
    @Published  var employeeID: String = ""
    @Published  var password: String = ""
    @Published  var employee: Employee?
    @Published var authStatus: AuthStatus?
    
    // MARK: - Fetch employee from cloudkit
    func fetchEmployee() {
        let predicate = NSPredicate(format: "employee_id == %@", employeeID)
        CloudKitManager.shared.fetchRecords(predicate: predicate) { result in
            switch result {
            case .success(let records):
                
                if let record = records.first {
                    let emp = Employee(
                        employee_id: record["employee_id"] as? String ?? "",
                        pass: record["password"] as? String,
                        email: record["email"] as? String ?? ""
                    )
                    
                    DispatchQueue.main.async { [self] in
                        self.employee = emp
                        self.currentRecordID = record.recordID
                        // If password field not empty then login otherwise register
                        if emp.pass != nil{
                            self.authStatus = .login
                        }else{
                            self.authStatus = .register
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.employee = nil
                        self.authStatus = .employeIdnotFound
                    }
                }
            case .failure(let error):
                // TODO: Handle the error
                print("Error fetching employee: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: Update record
    func updateRecord() -> Void {
        debugPrint("Update record started")
        guard let currentRecordID = currentRecordID else { return }
        
        CloudKitManager.shared.updateRecord(recordId: currentRecordID, value: password)
    }
    
}


enum LoginError: Error {
    case invalidEmployeeID
    case invalidPassword
}

enum AuthStatus {
    case login
    case register
    case employeIdnotFound
}
