//
//  BusAllocationModel.swift
//  BjitExpress
//
//  Created by Md. Mominul Islam on 18/5/23.
//

import Foundation
import CloudKit

struct BusAllocationModel: Hashable, CloudKitableProtocol, Identifiable {
    var id = UUID()
    let employeeId: String
    let reachTime: Int
    let allocatedBusNo: Int
    let date: Date
    let record: CKRecord

    init?(record: CKRecord) {
        self.employeeId = record["employee_id"] ?? ""
        self.reachTime = record["reach_time"] ?? -1
        self.allocatedBusNo = record["allocated_bus_no"] ?? -1
        self.date = (record["date"] as? Date)!
        self.record = record
    }
}
