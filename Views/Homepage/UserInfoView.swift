//
//  UserInfoView.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 24/11/23.
//

import SwiftUI

import FirebaseAuth

struct UserInfoView: View {
    @State private var loggedOut = false
    @State private var showAlert = false
    @State private var remainingExp = 2000
    @State private var currentExpProgress = 0.0
    @StateObject var userViewModel = UserViewModel()
    @StateObject var orderViewModel = OrderViewModel()
    @Binding var loggedIn: Bool
    var body: some View {
        NavigationView{
            if Auth.auth().currentUser?.uid != nil{
                ZStack{
                    Color(ColorString.lightGreen.colorText)
                        .ignoresSafeArea()
                    ScrollView{
                        VStack{
                            
                            ZStack{
                                ZStack{
                                    Rectangle()
                                        .frame(height: 80)
                                        .foregroundColor(.white)
                                        .cornerRadius(15)
                                        .padding(.horizontal, 5)
                                    
                                    HStack{
                                        Text("Food waste saved")
                                            .opacity(0.5)
                                        Spacer()
                                        
                                        Text("\(String(format: "%.1f", Double(orderViewModel.getTotalWeightSaved()) / 1000)) kg")
                                            .font(.title2)
                                            .bold()
                                        
                                    }.padding()
                                        .padding(.horizontal)
                                    
                                }
                                
                                
                            }.padding()
                            
                            HStack{
                                Image(systemName: "person")
                                Text("Your information")
                                    .bold()
                                
                            }.padding(.top)
                            
                            ZStack{
                                Rectangle()
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                
                                VStack{
                                    
                                    HStack{
                                        Text("Username")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text(userViewModel.currentUser?.name ?? "John Doe")
                                            .bold()
                                    }
                                    
                                    Divider()
                                        .background(Color.gray)
                                        .frame(height: 1)
                                        .padding(.bottom)
                                    
                                    
                                    
                                    HStack{
                                        Text("User ID")
                                            .foregroundColor(.gray)
                                        
                                        Spacer()
                                    }
                                    
                                    HStack{
                                        Spacer()
                                        Text(Auth.auth().currentUser?.uid ?? "User ID is null")
                                            .bold()
                                    }
                                    
                                    Divider()
                                        .background(Color.gray)
                                        .frame(height: 1)
                                        .padding(.bottom)
                                    
                                    HStack{
                                        Text("Email")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text(Auth.auth().currentUser?.email ?? "User email is null")
                                            .bold()
                                    }
                                    
                                    Divider()
                                        .background(Color.gray)
                                        .frame(height: 1)
                                        .padding(.bottom)
                                    
                                    HStack{
                                        Text("Address")
                                            .foregroundColor(.gray)
                                        
                                        Spacer()
                                    }
                                    
                                    HStack{
                                        Spacer()
                                        Text(userViewModel.currentUser?.address ?? "Swift Rd Boulevard No. 15/2")
                                            .bold()
                                    }
                                    
                                    
                                    
                                }.padding()
                            }.padding()
                            
                            Button(action: {
                                showAlert = true
                            }) {
                                Text("Log out")
                                    .font(.headline)
                                    .foregroundColor(.red)
                                    .frame(width: 300, height: 55)
                                    .background(Color.red.opacity(0.2))
                                    .cornerRadius(50)
                                    
                            }
                            
                            .padding(.vertical, 50)
                            .padding(.bottom, 100)
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Are you sure you want to log out?"),
                                    primaryButton: .cancel(),
                                    secondaryButton: .destructive(Text("Log out")) {
                                        do {
                                            try Auth.auth().signOut()
                                            loggedIn = false
                                            
                                        } catch let signOutError as NSError {
                                            print("Error signing out: \(signOutError.localizedDescription)")
                                        }
                                    }
                                )
                            }
                            Spacer()
                            
                        }
                    }.navigationBarTitle("Profile")
                    
                }.toolbarBackground(
                    Color(ColorString.lightGreen.colorText),
                    for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .edgesIgnoringSafeArea(.bottom)
                .onAppear{
                    userViewModel.fetchUserInfo()
                }
                
  
            }else{
                LoginView()
            }
            
            
        }
    }
    
}

#Preview {
    UserInfoView(loggedIn: .constant(true))
}

