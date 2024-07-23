//
//  RegisterView.swift
//  ECOMEAL
//
//  Created by Jason Leonardo on 10/09/23.
//

import SwiftUI

struct RegisterView: View {
    
    @State private var emailField: String = ""
    @State private var passwordField: String = ""
    @State private var confirmPasswordField: String = ""
    
    @State private var showAlert = false
    @State private var showAlertFormat = false
    @State private var navigateToRegisterView2 = false
    
    @State private var nextButtonClicked = false
    
    @ObservedObject var authViewModel = AuthViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationView {
            ZStack{
                Color(ColorString.lightGreen.colorText)
                    .ignoresSafeArea()
                VStack {
                    Image("AppLogoDark")
                        .resizable()
                        .frame(width: 200, height: 200)
                    Text("Register an account")
                        .font(.title)
                        .foregroundColor(Color(ColorString.darkGreen.colorText))
                        .bold()
                        .padding()
                    
                    TextField("Email", text: $emailField)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .textFieldStyle(OvalTextFieldStyle())
                        .padding()
                        .padding(.horizontal, 30)
                    
                    SecureField("Password", text: $passwordField)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .textFieldStyle(OvalTextFieldStyle())
                        .padding()
                        .padding(.horizontal, 30)
                    
                    SecureField("Confirm Password", text: $confirmPasswordField)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .textFieldStyle(OvalTextFieldStyle())
                        .padding()
                        .padding(.horizontal, 30)
                    
                    Button(action: {
                        nextButtonClicked.toggle()
                        authViewModel.addUserData(email: emailField, password: passwordField) { success in
                            if success {
                                print("User created successfully")
                                signInUser()
                            } else {
                                print("Failed to create user")
                                showAlert = true
                                nextButtonClicked.toggle()
                            }
                        }
                    }) {
                        Text("Next")
                            .foregroundColor(.white)
                            .bold()
                            .frame(width: 300, height: 50)
                            .background(.green)
                            .cornerRadius(12)
                    }
                    .shadow(color: .gray, radius: 3, x: 0, y: 2)
                    .padding(.top, 50)
                    .padding(.bottom, 30)
                    .alert("Error while registering. Make sure email is formatted correctly and passwords match.", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    }
                    .alert("That email address is invalid.", isPresented: $showAlertFormat) {
                        Button("OK", role: .cancel) { }
                    }
                    
                    // NavigationLink to RegisterView2
                    NavigationLink(
                        destination: RegisterView2(),
                        isActive: $navigateToRegisterView2,
                        label: {
                            EmptyView()
                        })
                    .hidden()
                }.onAppear {
                    authViewModel.fetchUserData()
                }.navigationBarBackButtonHidden(true)
                
                if nextButtonClicked{
                    LoadingView()
                }
                
            }.navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        BackButton(onButtonTap: { presentationMode.wrappedValue.dismiss()})
                    }
                }
        }.navigationBarBackButtonHidden(true)
    }
    
    func signInUser() {
        authViewModel.signIn(email: emailField, password: passwordField) { success, error in
            if success {
                print("Success")
                navigateToRegisterView2 = true
            } else {
                nextButtonClicked.toggle()
                showAlertFormat = true
                print("Failed to sign in: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func checkAccountInfo(){
        if passwordField != confirmPasswordField {
            showAlert = true
        } else if passwordField.isEmpty || confirmPasswordField.isEmpty {
            showAlert = true
        }
        else {
            
            authViewModel.addUserData(email: emailField, password: passwordField){
                success in
                if success{
                    navigateToRegisterView2 = true
                }else{
                    showAlert = true
                }
            }
            
        }
    }
    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
