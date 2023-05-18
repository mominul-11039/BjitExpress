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
    @Published var confirmPassword: String = ""
    @Published var cPasswordNotMatch:Bool?
    @Published  var employee: Employee?
    @Published var authStatus: AuthStatus?
    @Published var cludkitError: CloudKitError?
    
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
    func updateRecord() {
        cPasswordNotMatch = false
        debugPrint("Update record started")
        guard let currentRecordID = currentRecordID else { return }
        CloudKitManager.shared.updateRecord(recordId: currentRecordID, value: password)
    }
    
    
    // MARK: Login or Register button
    func loginOrRegister(){
        switch authStatus {
        case .none:
            self.fetchEmployee()
        case .login:
            print("login")
            
        case .register:
            print("register")
            registerUser()
            
        case .employeIdnotFound:
            print("Not found")
            authStatus = .none
        }
    }
    
    // MARK: Registration
    func registerUser(){
        if password == confirmPassword{
            print("Update record lgv 84")
            updateRecord()
        }else{
            cPasswordNotMatch = true
        }
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

enum CloudKitError: String, LocalizedError {
    case iCloudAccountNotFound
    case iCloudAccountNotDetermined
    case iCloudAccountRestricted
    case iCloudAccountUnknown
    case iCloudApplicationPermissionNotGranted
    case iCloudCouldNotFetchUserRecordID
    case iCloudCouldNotDiscoverUser
}
