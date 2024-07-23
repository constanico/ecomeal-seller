//
//  UserViewModel.swift
//  ECOMEAL
//
//  Created by Jason Leonardo on 07/10/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class UserViewModel: ObservableObject{
    
    @Published var currentUser: UserInfo?
    
    private var db = Firestore.firestore()
    
    func fetchUserInfo(){
        let userId = Auth.auth().currentUser?.uid ?? "1"
        db.collection(FilePathString.users.filePathText).document(userId).getDocument{ (document, error) in
            if let document = document, document.exists {
                if let data = try? document.data(as: UserInfo.self) {
                    self.currentUser = data
                }
            }
        }
    }
    
    func addUser(forUser userId: String, userInfo: UserInfo){
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            return
        }
        do{
            try db.collection(FilePathString.users.filePathText).document(userId).setData(from: userInfo)
        }
        catch{
            print("Error adding user: \(error.localizedDescription)")
        }
    }
    

    func addEcoPayBalance(forUserId userId: String, balanceToAdd: Double) {
        let userRef = db.collection(FilePathString.users.filePathText).document(userId)

        userRef.getDocument { document, error in
            if let document = document{
                if let currentBalance = document.data()?["ecoPayBalance"] as? Double {
                    
                    userRef.updateData(["ecoPayBalance": Double(currentBalance) + Double(balanceToAdd)]) { error in
                        if let error = error {
                            print("Error updating ecoPayBalance: \(error.localizedDescription)")
                        } else {
                            print("EcoPayBalance updated successfully")
                            self.fetchUserInfo()
                        }
                    }
                } else {
                    print("EcoPayBalance not found")
                }
            } else {
                print("Document does not exist ID: \(userId)")
            }
        }
    }
    
}
