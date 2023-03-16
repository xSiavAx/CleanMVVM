//
//  ContentView.swift
//  CleanMVVM
//
//  Created by st6111339 on 2023-03-15.
//

import SwiftUI

struct LoginView: View {
    @StateObject
    var viewModel: LoginViewModel
    
    var body: some View {
        Form {
            Section(
                content: {
                    TextField("Email", text: $viewModel.login)
                    SecureField("password", text: $viewModel.password)
                },
                header: {
                    Text("Credentials")
                }
            )
            Section {
                Button("Login") {
                    viewModel.didTapLogin()
                }
                
                Button("Register") {
                    viewModel.didTapRegister()
                }
            }
        }
        .navigationTitle("Welcome")
        .activityDimming($viewModel.isDimmed)
        .errorHandling($viewModel.errorAlert)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
            viewModel: .init(
                loginUseCase: DummyLoginUseCase(),
                onFinish: {}
            )
        )
    }
}
