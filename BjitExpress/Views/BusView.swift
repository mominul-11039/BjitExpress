//
//  BusView.swift
//  BjitExpress
//
//  Created by Md. Mominul Islam on 18/5/23.
//

import SwiftUI

struct BusView: View {
    var body: some View {
        VStack {
            BusListView()
            Spacer()
        }
    }
}

struct BusView_Previews: PreviewProvider {
    static var previews: some View {
        BusView()
    }
}
