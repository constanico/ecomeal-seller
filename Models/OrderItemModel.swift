//
//  OrderItemModel.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 06/11/23.
//

import Foundation
import FirebaseFirestoreSwift

struct OrderItem: Hashable, Identifiable, Codable{
    @DocumentID var id: String?
    var itemId: String
    var itemName: String
    var itemOldPrice: Float
    var itemNewPrice: Float
    var itemDescription: String?
    var itemQuantity: Int
    var itemWeight: Int
    var imageUrl: String?
}
