//
//  LoginPage.swift
//  ECOMEAL
//
//  Created by Jason Leonardo on 10/09/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct LoginView: View {
    
    @State private var emailField: String = ""
    @State private var passwordField: String = ""
    @State private var showAlert = false
    
    @State private var navigateToRegisterView = false
    @State private var proceedToHomeView = false
    
    @State private var loginButtonClicked = false
    
    @State private var rootIsActive = false
    
    @ObservedObject var authViewModel = AuthViewModel()
    var body: some View {
        
        NavigationView{
            ZStack{
                Color(ColorString.lightGreen.colorText)
                VStack{
                    
                    Image("AppLogoDark")
                        .resizable()
                        .frame(width: 200, height: 200)
                    
                    Text("ECOMEAL Seller")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color(ColorString.darkGreen.colorText))
                    
                    
                    TextField("Email", text: $emailField)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .textFieldStyle(OvalTextFieldStyle())
                        .padding()
                        .padding(.horizontal, 30)
                    
                    SecureField("Password", text: $passwordField)
                        .textFieldStyle(OvalTextFieldStyle())
                        .padding()
                        .padding(.horizontal, 30)
                        .padding(.bottom, 50)
                    
                    Button(action: {
                        loginButtonClicked.toggle()
                        signInUser()
                    }) {
                        Text("Log in")
                            .foregroundColor(.white)
                            .bold()
                            .frame(width: 300, height: 50)
                            .background(.green)
                            .cornerRadius(12)
                        
                    }.shadow(color: .gray, radius: 3, x: 0, y: 2)
                        .padding()
                        .padding(.bottom, 30)
                        .alert("Invalid email or password.", isPresented: $showAlert) {
                            Button("OK", role: .cancel) { }
                        }
                    
                    Text("Don't have an account?")
                    
                    Button(action: {
                        navigateToRegisterView = true
                    }) {
                        Text("Register an account")
                            .bold()
                            .foregroundColor(.green)
                    }
                    .padding()
                    
                    NavigationLink(
                        destination: RegisterView(),
                        isActive: $navigateToRegisterView,
                        label: {
                            EmptyView()
                        })
                    .hidden()
                    
                    NavigationLink(
                        destination: HomeView(),
                        isActive: $proceedToHomeView,
                        label: {
                            EmptyView()
                        })
                    .hidden()
                    
                }.onAppear {
                    UITabBar.appearance().isHidden = true
                }
                if loginButtonClicked{
                    LoadingView()
                }
            }.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
        
    }
    
    func signInUser() {
        authViewModel.signIn(email: emailField, password: passwordField) { success, error in
            if success {
                print("Success")
                proceedToHomeView.toggle()
            } else {
                loginButtonClicked.toggle()
                showAlert = true
                print("Failed to sign in: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
