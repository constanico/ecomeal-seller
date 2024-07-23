//
//  OrderStatusEnum.swift
//  ECOMEAL
//
//  Created by Jason Leonardo on 02/10/23.
//

import Foundation

enum OrderStatusString{
    case orderInCart
    case orderPending
    case orderOngoing
    case orderReadyForPickup
    case orderFinished
    case orderReviewed
    case orderCancelled
    
    var orderStatusText: String{
        switch self{
        case .orderInCart:
            return "Order in cart"
            
        case .orderPending:
            return "Order pending"
            
        case .orderOngoing:
            return "Order is ongoing"
            
        case .orderReadyForPickup:
            return "Order is ready for pickup"
            
        case .orderFinished:
            return "Order finished. Write a review"
            
        case .orderReviewed:
            return "Order finished"
            
        case .orderCancelled:
            return "Order has been cancelled"
        }
    }
}
