//
//  BusinessItemModel.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 28/10/23.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct BusinessItem: Hashable, Encodable, Decodable, Identifiable{
    @DocumentID var id: String?
    var itemId: String
    var itemName: String
    var itemOldPrice: Float
    var itemNewPrice: Float
    var itemDescription: String?
    var itemQuantity: Int
    var itemWeight: Int
    var itemIsListed: Bool
    var imageUrl: String?
}
