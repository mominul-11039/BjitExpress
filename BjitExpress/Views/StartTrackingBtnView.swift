//
//  StartTrackingBtnView.swift
//  BjitExpress
//
//  Created by Sadat Ahmed on 2023/05/19.
//

import SwiftUI

struct StartTrackingBtnView: View {
    // MARK: - PROPERTIES
    var location: LocationViewModel
    var busVM =  BusReservationViewModel.shared
    @AppStorage("\(Constant.currentDate)") var isCheckedIn: Bool = false
    @AppStorage("day-\(Constant.currentDate)") var isStartTracking: Bool = false
    let updateVM = UpdateViewModel.shared

    // MARK: - VIEW
        var body: some View {
            Button {
                if !isStartTracking {
                    isStartTracking = true
                    location.requestLocation()
                    NetworkManager().calculateDuration()
                    updateVM.startTimer()
                } else {
                    if !isCheckedIn {
                        isCheckedIn = true
                        busVM.userCheckedIn()
                        updateVM.stopTimer()
                    }
                }
            } label: {
                Text(isStartTracking ? "Checked In": "Start")
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                    .frame(maxWidth: 250)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(8)
            } //: BUTTON
            .padding()
            .background(.ultraThinMaterial)
            .disabled(isCheckedIn)
        }
}

