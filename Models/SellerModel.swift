//
//  SellerModel.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 28/10/23.
//

import Foundation
import FirebaseFirestoreSwift

struct UserInfo: Codable{
    @DocumentID var id: String?
    var name: String
    var address: String
    var ecoPayBalance: Double
    var ecoPoints: Double
}
