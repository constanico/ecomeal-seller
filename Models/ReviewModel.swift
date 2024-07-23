//
//  ReviewModel.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 24/11/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Review: Hashable, Encodable, Decodable, Identifiable{
    @DocumentID var id: String?
    var reviewerName: String
    var reviewBusinessId: String
    var reviewStarRating: Double
    var reviewContent: String
    var reviewTimestamp: String
}
