//
//  EngineerListView.swift
//  BjitExpress
//
//  Created by Md. Mominul Islam on 19/5/23.
//

import SwiftUI

struct EngineerListView: View {

    var engineerList: [BusAllocationModel] = []
    var busId: Int = 0

    var body: some View {
        VStack {
            Text("Bus #00\(busId)")
            Text("Employee List")
            List(engineerList) { list in
                Text(list.employeeId)
            }
            .listStyle(.plain)
        }
    }
}

struct EngineerListView_Previews: PreviewProvider {
    static var previews: some View {
        EngineerListView(engineerList: [])
    }
}
