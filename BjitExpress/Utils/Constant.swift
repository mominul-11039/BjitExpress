//
//  Constant.swift
//  BjitExpress
//
//  Created by Md. Mominul Islam on 17/5/23.
//

import Foundation
import CoreLocation

public class Constant {
    public static let cloudKitContainerName = "iCloud.TeamCombine.bjitgroup.upskilldev"
    public static let coreDataContainerName = "BjitExpress"
    public static var loggedInUserId: String = "11039"
    public static var APIKEY: String = "Enter_your_key"
    public static let busAllocationRecordType = "Bus_Allocation"
    public static var userLocation: CLLocationCoordinate2D?
    public static let busList: [Int] = [1, 2, 3, 4, 5]
    func getCurrentDate()-> String {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        return "\(day)/\(month)/\(year)"
    }
    func getStartTime() -> Date? {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateString = "\(getCurrentDate()) 05: 00"
        let startDate = formatter.date(from: dateString)
        return startDate
    }

    func getEndTime() -> Date? {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateString = "\(getCurrentDate()) 08: 00"
        let endDate = formatter.date(from: dateString)
        return endDate
    }
}
