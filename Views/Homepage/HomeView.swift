//
//  HomeView.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 28/10/23.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @State private var loggedIn = true
    @State private var selectedTabIndex = 0
    var body: some View {
        
        if loggedIn && Auth.auth().currentUser?.uid != nil{
            NavigationView{
                TabView(selection: $selectedTabIndex){
                    BusinessView()
                        .tabItem{
                            Image(systemName: "building")
                            Text("Businesses")
                        }.tag(0)
                    
                    OrderView()
                        .tabItem{
                            Image(systemName: "list.bullet.rectangle.portrait")
                            Text("Orders")
                        }.tag(1)
                    
                    FinanceView()
                        .tabItem{
                            Image(systemName: "dollarsign.square.fill")
                            Text("Finance")
                        }.tag(2)
                    
                    UserInfoView(loggedIn: $loggedIn)
                        .tabItem{
                            Image(systemName: "person.circle.fill")
                            Text("Profile")
                        }.tag(3)
                }.navigationBarBackButtonHidden(true)
                
            }.navigationBarBackButtonHidden(true)
        }
        else{
            LoginView()
                .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    HomeView()
}
