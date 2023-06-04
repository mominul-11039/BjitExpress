//
//  BjitExpressApp.swift
//  BjitExpress
//
//  Created by Md. Mominul Islam on 15/5/23.
//

import SwiftUI

@main
struct BjitExpressApp: App {

    @Environment(\.scenePhase) private var scenePhase
    let updateVM = UpdateViewModel.shared

    var body: some Scene {
        WindowGroup {
            let userId = UserDefaults.standard.string(forKey: Constant.loggedInUserIdString) ?? ""
            if userId != "" {
                MainView()
            } else {
                LoginScreen()
            }
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                let status = UserDefaults.standard.bool(forKey: "Constant.isStartTracking")
                if status {
                    updateVM.startTimer()
                }
                break
            case .inactive, .background:
                updateVM.stopTimer()
                break
            @unknown default:
                break
            }
        }
    }
}
