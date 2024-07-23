//
//  FilePathEnum.swift
//  ECOMEAL
//
//  Created by Jason Leonardo on 01/10/23.
//

import Foundation

enum FilePathString{
    
    case sellers
    case users
    case business
    case businessList
    case businessItems
    case shoppingCarts
    case shoppingCartBusinesses
    case cartItems
    case orders
    case orderItems
    case reviews
    
    var filePathText: String{
        switch self{
            
        case .sellers:
            return "sellers"
            
        case .users:
            return "users"
            
        case .business:
            return "businesses"
            
        case .businessList:
            return "businessList"
            
        case .businessItems:
            return "items"
            
        case .shoppingCarts:
            return "shoppingCarts"
            
        case .shoppingCartBusinesses:
            return "cartBusinesses"
            
        case .cartItems:
            return "cartItems"
            
        case .orders:
            return "orders"
            
        case .orderItems:
            return "orderItems"
            
        case .reviews:
            return "reviews"
            
            
        }
    }
    
}
