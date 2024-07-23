//
//  MessagingViewModel.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 26/11/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class MessagingViewModel: ObservableObject {
    private var db = Firestore.firestore()

    @Published var messages: [Message] = []

    func sendMessage(orderId: String, text: String, senderID: String, receiverID: String) {
        let newMessage = Message(text: text, senderID: senderID, receiverID: receiverID, isRead: false, timestamp: Date())

        do {
            try db.collection("orders").document(orderId).collection("messages").addDocument(from: newMessage)
        } catch {
            print("Error sending message: \(error.localizedDescription)")
        }
    }

    func markMessageAsRead(orderId: String, messageID: String) {
        let messageRef = db.collection("orders").document(orderId).collection("messages").document(messageID)
        messageRef.updateData(["isRead": true]) { error in
            if let error = error {
                print("Error marking message as read: \(error.localizedDescription)")
            }
        }
    }

    func fetchMessages(orderId: String) {
        db.collection("orders").document(orderId).collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching messages: \(error.localizedDescription)")
                    self.messages = []
                } else if let documents = snapshot?.documents {
                    let messages = documents.compactMap { document -> Message? in
                        do {
                            return try document.data(as: Message.self)
                        } catch {
                            print("Error decoding message: \(error.localizedDescription)")
                            return nil
                        }
                    }
                    self.messages = messages
                }
            }
    }
    
    func countUnreadMessages() -> Int {
        let currentUserUID = Auth.auth().currentUser?.uid ?? "1"
        
        let unreadMessagesCount = messages.filter { message in

            return message.senderID != currentUserUID && !message.isRead
        }.count
        
        
        return unreadMessagesCount
    }
}

