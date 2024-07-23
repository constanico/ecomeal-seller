//
//  OrderModel.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 06/11/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Order: Hashable, Encodable, Decodable, Identifiable{
    @DocumentID var id: String?
    var orderId: String
    var orderUserId: String
    var orderUserName: String
    var orderSellerId: String
    var orderBusinessId: String
    var orderBusinessName: String
    var orderBusinessLatitude: Double
    var orderBusinessLongitude: Double
    var orderBusinessAddress: String
    var orderStatus: String
    var orderTotal: Float
    var orderMoneySaved: Float
    var orderTotalWeight: Int
    var orderPaymentMethod: String
    var orderItems: [OrderItem]?
    var orderTimestamp: String
    var orderCashback: Float
    var imageUrl: String?
}
