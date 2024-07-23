//
//  BusinessModel.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 28/10/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Business: Decodable, Encodable, Identifiable, Hashable{
    @DocumentID var id: String?
    var businessSellerId: String
    var businessId: String
    var businessName: String
    var businessCategory: String
    var businessRating: Double
    var businessLatitude: Double
    var businessLongitude: Double
    var businessAddress: String
    var businessIsOpen: Bool
    var imageUrl: String?
}
