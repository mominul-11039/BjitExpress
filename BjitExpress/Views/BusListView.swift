//
//  BusListView.swift
//  BjitExpress
//
//  Created by Md. Mominul Islam on 18/5/23.
//

import SwiftUI

struct BusListView: View {

    @StateObject private var busVM = BusViewModel()
    let coreDataVM = CoreDataViewModel.shared

    var body: some View {
        NavigationView {
            VStack {
                Text("Bus List")
                List {
                    Section (
                        header:
                            HStack {
                                Text("Bus No")
                                Spacer()
                                Text("No of Engineers")
                                Spacer()
                                Text("Departure time")
                            }
                    ) {
                        ForEach(coreDataVM.todaysBusSchedule, id: \.self) { item in
                            NavigationLink(destination: {
                                EngineerListView(engineerList: busVM.getBusWiseEmployeeList(busNo: Int(item.bus_no)), busId: Int(item.bus_no))
                            }){
                                HStack {
                                    Text("Bus #00\(item.bus_no)")
                                    Spacer()
                                    Text(busVM.myALlocatedbus == item.bus_no ? "\(busVM.getBusWiseEmployeeCount(busNo: Int(item.bus_no)))\nYour Allocated Bus" : "\(busVM.getBusWiseEmployeeCount(busNo: Int(item.bus_no)))")
                                        .multilineTextAlignment(TextAlignment.center)
                                    Spacer()
                                    Text(item.departure_time ?? "")
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

struct BusListView_Previews: PreviewProvider {
    static var previews: some View {
        BusListView()
    }
}
