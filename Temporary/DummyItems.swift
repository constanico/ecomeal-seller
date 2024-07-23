//
//  DummyItems.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 28/10/23.
//

import Foundation
import SwiftUI
import FirebaseAuth

var dummyId = "120F6B7D-3D12-41B8-9EA0-8614C938EDF1"

var businessDummy = Business(businessSellerId: "1", businessId: dummyId, businessName: "iPhone's 15 Pro Max Italian Restaurant", businessCategory: "Western", businessRating: 4.5, businessLatitude: 0, businessLongitude: 0, businessAddress: "Deket Apple Park, Cupertino", businessIsOpen: true)


var businessItemsDummy =
[
    
    BusinessItem(itemId: "001", itemName: "Hamburger", itemOldPrice: 20000, itemNewPrice: 8000, itemQuantity: 1, itemWeight: 100, itemIsListed: true),
    BusinessItem(itemId: "002", itemName: "Spaghetti", itemOldPrice: 30000, itemNewPrice: 15000, itemQuantity: 1, itemWeight: 100, itemIsListed: true),
    BusinessItem(itemId: "003", itemName: "Coffee", itemOldPrice: 15000, itemNewPrice: 6000, itemQuantity: 1, itemWeight: 100, itemIsListed: true),
    BusinessItem(itemId: "004", itemName: "Sandwich", itemOldPrice: 20000, itemNewPrice: 9000, itemQuantity: 1, itemWeight: 100, itemIsListed: true),
    BusinessItem(itemId: "005", itemName: "Pizza Slice", itemOldPrice: 15000, itemNewPrice: 10000, itemQuantity: 1, itemWeight: 100, itemIsListed: true),
    BusinessItem(itemId: "006", itemName: "Rice", itemOldPrice: 6000, itemNewPrice: 3000, itemQuantity: 1, itemWeight: 100, itemIsListed: true),
    BusinessItem(itemId: "007", itemName: "Apple Tea", itemOldPrice: 10000, itemNewPrice: 4000, itemQuantity: 1, itemWeight: 100, itemIsListed: true),
    BusinessItem(itemId: "008", itemName: "Super Watermelon Blizzard Drink Large", itemOldPrice: 10000, itemNewPrice: 6000, itemQuantity: 1, itemWeight: 100, itemIsListed: true)
    
]

let itemImage = UIImage(imageLiteralResourceName: "FoodIcon")

var itemsDummy =
[
    Item(itemId: "001", itemName: "Hamburger", itemOldPrice: 20000, itemNewPrice: 8000, itemQuantity: 1, itemWeight: 100, image: itemImage),
    Item(itemId: "002", itemName: "Spaghetti", itemOldPrice: 30000, itemNewPrice: 15000, itemQuantity: 1, itemWeight: 100, image: itemImage),
    Item(itemId: "003", itemName: "Coffee", itemOldPrice: 15000, itemNewPrice: 6000, itemQuantity: 1, itemWeight: 100, image: itemImage),
    Item(itemId: "004", itemName: "Sandwich", itemOldPrice: 20000, itemNewPrice: 9000, itemQuantity: 1, itemWeight: 100, image: itemImage),
    Item(itemId: "005", itemName: "Pizza Slice", itemOldPrice: 15000, itemNewPrice: 10000, itemQuantity: 1, itemWeight: 100, image: itemImage)
    
]

let emptyBusinessInfo = Business(businessSellerId: Auth.auth().currentUser?.uid ?? "", businessId: UUID().uuidString, businessName: "", businessCategory: "", businessRating: 0.0, businessLatitude: 0, businessLongitude: 0, businessAddress: "", businessIsOpen: true)

let uploadToFirebase = Item(itemId: "0", itemName: "", itemOldPrice: 0, itemNewPrice: 0, itemQuantity: 0, itemWeight: 0, image: itemImage)

let orderDummy = Order(orderId: "1", orderUserId: "1", orderUserName: "Mike Dane", orderSellerId: "1", orderBusinessId: "1", orderBusinessName: "Wow", orderBusinessLatitude: 1, orderBusinessLongitude: 1, orderBusinessAddress: "Close to your house", orderStatus: OrderStatusString.orderReadyForPickup.orderStatusText, orderTotal: 100000, orderMoneySaved: 20000, orderTotalWeight: 500, orderPaymentMethod: "Cash", orderTimestamp: getDateString(date: Date()), orderCashback: 1000)

var orderItemDummy = OrderItem(itemId: "", itemName: "", itemOldPrice: 0, itemNewPrice: 0, itemQuantity: 0, itemWeight: 0)

