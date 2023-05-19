//
//  BusReservationViewModel.swift
//  BjitExpress
//
//  Created by Sadat Ahmed on 2023/05/19.
//

import Foundation
import Combine
import CloudKit

class BusReservationViewModel: ObservableObject {
    let  coreDataViewModel = CoreDataViewModel.shared
    @Published var busAllocationList: [BusAllocationModel] = []
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
        busAllocationList.forEach { item in
            if item.employeeId == Constant.loggedInUserId {
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

    func bookSeat(busNo: Int, arrivalTime: (hour: Int, minute: Int)) {
        guard busNo >= 0 && busNo < coreDataViewModel.todaysBusSchedule.count else {
            return
        }
        
        let busInfo = coreDataViewModel.todaysBusSchedule[busNo]
        guard let deptTime = busInfo.departure_time else {
            return
        }
        
        print(deptTime)
        if canReachBeforeBusDept(deptTime: deptTime, arrivalTime: arrivalTime) && getBusWiseEmployeeCount(busNo: busNo) <= 50 {
            let record = CKRecord(recordType: Constant.busAllocationRecordType)
            record["employee_id"] = "11399"
            record["allocated_bus_no"] = busInfo.bus_no
            record["reach_time"] = (arrivalTime.hour * 60) + arrivalTime.minute
            record["date"] = Date()
            let busAllocatedModel = BusAllocationModel(record: record)!
            saveUserData(busAllocationModel: busAllocatedModel)
        } else {
            bookSeat(busNo: busNo + 1, arrivalTime: arrivalTime)
        }
    }
    
    func canReachBeforeBusDept(deptTime: String, arrivalTime: (hour: Int, minute: Int)) -> Bool {
        let calendar = Calendar.current
        
        let currentDateTime = Date()
        let currentComponents = calendar.dateComponents([.hour, .minute], from: currentDateTime)
        
        guard let currentHour = currentComponents.hour, let currentMinute = currentComponents.minute else {
            return false
        }
        
        let currentTotalMinutes = currentHour * 60 + currentMinute
        let deptComponents = parseTime(deptTime)
        let deptHour = deptComponents.hour
        let deptMinute = deptComponents.minute
        
        let deptTotalMinutes = deptHour * 60 + deptMinute
        let arrivalTotalMinutes = arrivalTime.hour * 60 + arrivalTime.minute
        
        return currentTotalMinutes + arrivalTotalMinutes <= deptTotalMinutes
    }
    
    func parseTime(_ time: String) -> (hour: Int, minute: Int) {
        let components = time.split(separator: ":")
        if components.count == 2, let hour = Int(components[0]), let minute = Int(components[1]) {
            return (hour: hour, minute: minute)
        }
        return (hour: 0, minute: 0)
    }

    func getDeptTime() -> Int? {
        guard let departureTime = coreDataViewModel.todaysBusSchedule[1].departure_time else {
            return nil
        }
        return Int(departureTime)
    }

    func saveUserData(busAllocationModel: BusAllocationModel) {
        CloudKitViewModel.add(item: busAllocationModel) { result in
            switch (result) {
            case .success(_):
                break
            case .failure(_):
                break
            }
        }
    }
}
