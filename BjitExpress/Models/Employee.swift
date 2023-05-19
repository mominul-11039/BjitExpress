//
//  Employee.swift
//  BjitExpress
//
//  Created by YeasirArefinTusher-11702 on 18/5/23.
//

import Foundation
import CloudKit

struct Employee: CloudKitableProtocol {
    var record: CKRecord
    let employee_id: String
    var password: String?
    let email: String
    
    
    init?(record: CKRecord) {
        self.employee_id = record["employee_id"] ?? ""
        self.password = record["password"] ?? ""
        self.email = record["email"] ?? ""
        self.record = record
    }
}
