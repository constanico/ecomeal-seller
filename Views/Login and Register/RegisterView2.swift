//
//  RegisterView2.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 28/10/23.
//

import SwiftUI
import FirebaseAuth

struct RegisterView2: View {
    @State private var nameField: String = ""
    @State private var addressField: String = ""
    @State private var showAlert = false
    
    @State private var proceedToHomeView = false
    
    @ObservedObject private var sellerViewModel = UserViewModel()
    
    var body: some View {
        
        NavigationView{
            ZStack{
                Color(ColorString.lightGreen.colorText)
                VStack {
                    
                    Text("Register an account")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color(ColorString.darkGreen.colorText))
                        .padding(.bottom, 50)
                    
                    
                    
                    TextField("Enter your name", text: $nameField)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .textFieldStyle(OvalTextFieldStyle())
                        .padding()
                        .padding(.horizontal, 30)
                    
                    HStack{
                        Text("Enter your address")
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }.padding(.horizontal, 30)
                    
                    
                    TextEditor(text: $addressField)
                        .frame(height: 100)
                        .foregroundColor(.gray)
                        .cornerRadius(10)
                        .shadow(color: .gray.opacity(0.3), radius: 5, y: 5)
                        .padding(.horizontal, 30)

                    Button(action: {
                        if nameField.isEmpty{
                            showAlert = true
                        }else if addressField.isEmpty{
                            showAlert = true
                        }else{
                            addUserInfo()
                            proceedToHomeView = true
                        }
                    }) {
                        Text("Register")
                            .foregroundColor(.white)
                            .bold()
                            .frame(width: 300, height: 50)
                            .background(.green)
                            .cornerRadius(12)
                    }
                    .shadow(color: .gray, radius: 3, x: 0, y: 2)
                    .padding()
                    .padding(.bottom, 30)
                    .padding(.top, 70)
                    
                    .alert("Please enter your name or address.", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    }
                    
                    NavigationLink(
                        destination: HomeView(),
                        isActive: $proceedToHomeView,
                        label: {
                            EmptyView()
                        })
                    .hidden()
                   
                }.navigationBarBackButtonHidden(true)
            }.edgesIgnoringSafeArea(.all)
                .navigationBarBackButtonHidden(true)
        }.navigationBarBackButtonHidden(true)
    }
    
    func addUserInfo(){
        let sellerInfo = UserInfo(name: nameField, address: addressField, ecoPayBalance: 0, ecoPoints: 0)
        sellerViewModel.fetchUserInfo()
        sellerViewModel.addUser(forUser: Auth.auth().currentUser?.uid ?? "", userInfo: sellerInfo)
    }
    
}


struct RegisterView2_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView2()
    }
}

