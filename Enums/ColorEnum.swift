//
//  ColorEnum.swift
//  ECOMEAL
//
//  Created by Jason Leonardo on 10/10/23.
//

import Foundation

enum ColorString{
    case lightGray
    case lightGreen
    case darkGreen
    
    var colorText: String{
        switch self{
        case .lightGray:
            return "lightGray"
            
        case .lightGreen:
            return "lightGreen"
            
        case .darkGreen:
            return "darkGreen"
       
        }
    }
}
