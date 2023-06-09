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
    var body: some View {
        NavigationView{
            VStack {
                Text("Welcome")
                    .fontWeight(.heavy)
                
                TextField("Employee ID", text: $viewModel.employeeID)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding(5)
                
                switch viewModel.authStatus {
                case .login:
                    SecureField("Enter Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(5)
                case .register:
                    SecureField("Create New Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(5)
                    SecureField("Confirm Password", text: $viewModel.confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(5)
                case .employeIdnotFound:
                    Text("Employee ID not found. Please write correct Emplyee ID")
                        .foregroundColor(.red)
                case .none:
                    EmptyView()
                case .some(.authenticated):
                    NavigationLink(destination: MainView().navigationBarBackButtonHidden(true), isActive: $viewModel.isUserActive) {
                            EmptyView()
                        }
                }
                
                switch viewModel.cPasswordNotMatch{
                case true:
                    Text("Two password not match!")
                        .foregroundColor(.red)
                        .padding(1)
                case false:
                    EmptyView()
                }
                
                
                Button($viewModel.authStatus.wrappedValue == .register ? "Register" : "Login" ) {
                    viewModel.loginOrRegister()
                }
                
            }
            .padding()
        }
        }
        
}

