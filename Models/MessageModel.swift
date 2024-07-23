//
//  MessageModel.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 26/11/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Message: Hashable, Identifiable, Codable {
    @DocumentID var id: String?
    var text: String
    var senderID: String
    var receiverID: String
    var isRead: Bool
    var timestamp: Date
}
