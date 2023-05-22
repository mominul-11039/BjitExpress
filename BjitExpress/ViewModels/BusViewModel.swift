//
//  BusViewModel.swift
//  BjitExpress
//
//  Created by Md. Mominul Islam on 18/5/23.
//

import Foundation
import CloudKit
import Combine

class BusViewModel: ObservableObject {
    @Published var busAllocationList: [BusAllocationModel] = []
    var vm: CloudKitViewModel = CloudKitViewModel()
    @Published var myALlocatedbus: Int = 0
    var cancellables = Set<AnyCancellable>()

    init() {
        getBusAllocationList()
    }

    func getBusAllocationList() {
        let predicate = NSPredicate(format: "(date >= %@)", Constant().getStartTime()! as CVarArg)
        let recordType = "Bus_Allocation"
        CloudKitViewModel.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] returnedItems in
                self?.busAllocationList = returnedItems
            }
            .store(in: &cancellables)
    }

    func getBusWiseEmployeeCount(busNo: Int) -> Int {
        var count = 0
        let userId = UserDefaults.standard.string(forKey: Constant.loggedInUserIdString) ?? ""
        busAllocationList.forEach { item in
            if item.employeeId == userId {
                DispatchQueue.main.async {
                    self.myALlocatedbus = item.allocatedBusNo
                }
            }
            if item.allocatedBusNo == busNo {
                count += 1
            }
        }
        return count
    }

    
    func getBusWiseEmployeeList(busNo: Int) -> [BusAllocationModel] {
        var employeeList: [BusAllocationModel] = []
        busAllocationList.forEach { item in
            if item.allocatedBusNo == busNo {
                employeeList.append(item)
            }
        }
        return employeeList
    }
}
