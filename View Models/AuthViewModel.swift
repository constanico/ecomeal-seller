//
//  AuthViewModel.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 28/10/23.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AuthViewModel: ObservableObject {
    private var db = Firestore.firestore()
    
    @Published var user: AuthInfo?
    
    func addUserData(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                completion(false)
            } else {
                print("User created successfully")
                completion(true)
              
            }
        }
    }
    
    func checkAccountExists(email: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in
            if let error = error {
                print("Error checking email existence: \(error.localizedDescription)")
                completion(false)
            } else if let signInMethods = methods {
                if signInMethods.isEmpty {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }

    
    func signIn(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Failed to sign in: \(error.localizedDescription)")
                completion(false, error)
            } else {
                print("Successfully signed in")
                completion(true, nil)
            }
        }
    }
    
    func fetchUserData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        db.collection(FilePathString.sellers.filePathText).document(userId).getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = try? document.data(as: AuthInfo.self) {
                    self.user = data
                }
            }
        }
    }
}

