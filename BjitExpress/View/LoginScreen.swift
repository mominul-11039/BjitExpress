//
//  LoginScreen.swift
//  BjitExpress
//
//  Created by YeasirArefinTusher-11702 on 18/5/23.
//

import Foundation
import SwiftUI

struct LoginScreen: View {
    @ObservedObject private var viewModel = LoginViewModel()
    @State private var showPassword = false
    
    var body: some View {
        VStack {
            TextField("Employee ID", text: $viewModel.employeeID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
            
            if viewModel.employee != nil {
                if !viewModel.passwordExists{
                    SecureField("Create New Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    SecureField("Confirm Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }else{
                    SecureField("Enter Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                
            }
            
            Button(showPassword ? "Register" : "Login") {
                viewModel.fetchEmployee()
                if viewModel.passwordExists && viewModel.employee != nil{
                    // TODO: Implement login logic
                    showPassword = false
                }else if !viewModel.passwordExists && viewModel.employee != nil{
                    // TODO: Implement registration logic
                    viewModel.updateRecord()
                    showPassword = true
                }
                
            }
            .padding()
        }
    }
}
