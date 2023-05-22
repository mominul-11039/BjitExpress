//
//  LoginViewModel.swift
//  BjitExpress
//
//  Created by YeasirArefinTusher-11702 on 18/5/23.
//

import Foundation
import SwiftUI
import CloudKit
import Combine

class LoginViewModel : ObservableObject{
    
    var cancellables = Set<AnyCancellable>()
    var coreDataVm = CoreDataViewModel()
    
    
    @Published  var employeeID: String = ""
    @Published  var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var cPasswordNotMatch:Bool = false
    @Published  var employee: Employee?
    @Published var authStatus: AuthStatus?
    @Published var cludkitError: CloudKitError?
    @Published var authenticated: Bool = false
    @Published var isUserActive = false
    
    // MARK: - Fetch employee from cloudkit
    func fetchEmployee(){
        let predicate = NSPredicate(format: "employee_id == %@", employeeID)
        let recordType = "User"
        CloudKitViewModel.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] returnedItems in
                
                self?.employee = returnedItems.first
                
                //   If password field not empty then login otherwise register
                if self?.employee?.password != ""{
                    self?.authStatus = .login
                }else{
                    self?.authStatus = .register
                }
                
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: Update record
    func updateEmplolyeeRecord() {
        cPasswordNotMatch = false
        if let employee = self.employee {
            let record = employee.record
            record.setValuesForKeys(["password": password])
            
            CKContainer(identifier: "iCloud.TeamCombine.bjitgroup.upskilldev")
                .publicCloudDatabase.save(record) { record, error in
                    if let record = record {
                        DispatchQueue.main.async {
                            self.password=""
                            self.authStatus = .login
                        }
                    }
                    if let error = error{
                        print(error.localizedDescription)
                        self.password=""
                        self.authStatus = .none
                    }
                }
        }
    }

    // MARK: Login or Register button
    func loginOrRegister(){
        switch authStatus {
        case .none:
            self.fetchEmployee()
        case .login:
            login()
        case .register:
            registerUser()
        case .employeIdnotFound:
            authStatus = .none
        case .authenticated:
            print("user authenticated")
        }
    }

    // MARK: Registration
    func registerUser(){
        if password == confirmPassword{
            updateEmplolyeeRecord()
        }else{
            cPasswordNotMatch = true
        }
    }

    // MARK: Login
    func login(){
        if let password = employee?.password {
            if employee?.password == password{
                authStatus = .authenticated
                self.isUserActive = true
                self.password=""
                UserDefaults.standard.set(employee?.employee_id, forKey: Constant.loggedInUserIdString)
                coreDataVm.saveEmployeeInfo(employeeId: employee?.email ?? "", email: employee?.employee_id ?? "")
            }else{
                self.password=""
                authStatus = .none
                self.isUserActive = false
            }
        }
    }

    // MARK: Enums
    enum LoginError: Error {
        case invalidEmployeeID
        case invalidPassword
    }
    
    enum AuthStatus {
        case login
        case register
        case employeIdnotFound
        case authenticated
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
}
