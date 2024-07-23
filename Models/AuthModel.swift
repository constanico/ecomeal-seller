//
//  AuthModel.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 28/10/23.
//

import Foundation
import FirebaseFirestoreSwift

struct AuthInfo: Identifiable, Codable, Hashable{
    @DocumentID var id: String? = UUID().uuidString
    var email: String
    var password: String
}

