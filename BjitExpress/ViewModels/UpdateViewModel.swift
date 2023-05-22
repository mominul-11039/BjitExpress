//
//  UpdateViewModel.swift
//  BjitExpress
//
//  Created by Md. Mominul Islam on 22/5/23.
//

import Foundation

class UpdateViewModel: ObservableObject {
    static let shared: UpdateViewModel = UpdateViewModel()
    var cloudKitViewModel = CloudKitViewModel()
    var coreDataViewModel = CoreDataViewModel()
    @Published var busAllocationList: [BusAllocationModel] = []
    @Published var myALlocatedbus: Int = 0
    var same = ""
    private var timer: Timer? = nil

    func updateData() {
        coreDataViewModel.busTimeReschedule()
        NetworkManager().calculateDuration()
    }

    func startTimer() {
        guard timer == nil else {
            return
        }
        same = "same"
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            print("Timer fired! same")
            self.updateData()
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        print("Timer stopped \(same)")
    }
}
