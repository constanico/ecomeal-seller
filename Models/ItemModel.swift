//
//  ItemModel.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 30/10/23.
//

import Foundation
import SwiftUI

struct Item : Hashable{
    var itemId: String
    var itemName: String
    var itemOldPrice: Float
    var itemNewPrice: Float
    var itemDescription: String?
    var itemQuantity: Int
    var itemWeight: Int
    var image: UIImage
}
