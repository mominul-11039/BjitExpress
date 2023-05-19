//
//  CoreDataViewModel.swift
//  BjitExpress
//
//  Created by Md. Mominul Islam on 16/5/23.
//

import Foundation
import CoreData

class CoreDataViewModel {

    static let shared = CoreDataViewModel()
    var todaysBusSchedule: [BusInfo] = []
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: Constant.coreDataContainerName)
        container.loadPersistentStores { storeDesc, error in
            if let error = error {
                print("Core Data error : \(error)")
            }
        }
        addTodaysBusSchedule()
    }

    func saveData() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving. \(error)")
        }
    }

    func fetchTodaysBusList(completion: @escaping([BusInfo]) ->()) {
        let predicate = NSPredicate(format: "current_date == %@", Constant().getCurrentDate())
        let request = NSFetchRequest<BusInfo>(entityName: "BusInfo")
        request.predicate = predicate
        var todaysBusList: [BusInfo] = []
        do {
            todaysBusList = try container.viewContext.fetch(request)
            todaysBusSchedule = todaysBusList
            completion(todaysBusList)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }

    func addTodaysBusSchedule() {
        fetchTodaysBusList { todaysBusList in
            if todaysBusList.count == 0 {
                let busScheduleList: [BusModel] = getBusList()
                busScheduleList.forEach { busModel in
                    let busInfo = BusInfo(context: self.container.viewContext)
                    busInfo.bus_no = Int64(busModel.busID)
                    busInfo.current_date = Constant().getCurrentDate()
                    busInfo.departure_time = busModel.departureTime
                    self.saveData()
                }
            }
        }
    }
    
    // MARK: Save employee info into CoreData
    func saveEmployeeInfo(employeeId: String, email: String) {
        if checkIfEmployeeExists(employeeId: employeeId){
            print("employee already exists")
        }else{
            let employeeInfo = CDEmployee(context: container.viewContext)
            employeeInfo.employee_id = employeeId
            employeeInfo.email = email
            saveData()
        }
    }
    
    // MARK: Check if employe already exists in coredata
    func checkIfEmployeeExists(employeeId: String) -> Bool {
            let predicate = NSPredicate(format: "employee_id == %@", employeeId)
            let request = NSFetchRequest<CDEmployee>(entityName: "CDEmployee")
            request.predicate = predicate
            var employeeList: [CDEmployee] = []
            do {
                employeeList = try container.viewContext.fetch(request)
                if employeeList.count > 0 {
                    return true
                }
            } catch let error {
                print("Error fetching. \(error)")
            }
            return false
        }
    
    // MARK: Fetch Employee infor
    func fetchEmployeeInfo(employeeId: String) -> CDEmployee? {
            let predicate = NSPredicate(format: "employee_id == %@", employeeId)
            let request = NSFetchRequest<CDEmployee>(entityName: "CDEmployee")
            request.predicate = predicate
            var employeeList: [CDEmployee] = []
            do {
                employeeList = try container.viewContext.fetch(request)
                if employeeList.count > 0 {
                    return employeeList[0]
                }
            } catch let error {
                print("Error fetching. \(error)")
            }
            return nil
        }
    
    
}
