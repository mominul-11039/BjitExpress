//
//  ContentView.swift
//  BjitExpress
//
//  Created by Md. Mominul Islam on 15/5/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    let coreDataVM: CoreDataViewModel = CoreDataViewModel.shared

    var body: some View {
        MainView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
