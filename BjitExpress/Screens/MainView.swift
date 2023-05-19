//
//  MainView.swift
//  BjitExpress
//
//  Created by Md. Mominul Islam on 18/5/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            BusView()
                .tabItem {
                    Label("Bus", systemImage: "car.fill")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
