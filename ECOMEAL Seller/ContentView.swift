//
//  ContentView.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 28/10/23.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    var body: some View {
        ZStack {
            if Auth.auth().currentUser?.uid != nil{
                HomeView()
            }
            else{
                LoginView()
            }
        }
      
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
