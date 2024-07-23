//
//  ReviewViewModel.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 24/11/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class BusinessReviewViewModel: ObservableObject {
    private var db = Firestore.firestore()

    @Published var reviews: [Review] = []
    
    func getOverallRating(forBusinessId businessId: String, addRating: Double) -> Double {

        let reviewsForBusiness = reviews.filter { $0.reviewBusinessId == businessId }
        let totalRatings = reviewsForBusiness.map { $0.reviewStarRating }.reduce(0, +)

        if reviewsForBusiness.isEmpty {
            return 0.0
        } else {
            if addRating > 0{
                return (Double(totalRatings) + addRating) / (Double(reviewsForBusiness.count) + 1)
            }
            else{
                return Double(totalRatings) / (Double(reviewsForBusiness.count))
            }
        }
    }

 
    func countTotalReviews(forBusinessId businessId: String) -> Int {
        return reviews.filter { $0.reviewBusinessId == businessId }.count
    }
    

    func addReview(toBusiness businessId: String, review: Review) {
        do {
            try db.collection(FilePathString.business.filePathText).document(businessId).collection(FilePathString.reviews.filePathText).addDocument(from: review)
        } catch {
            print("Error adding review: \(error.localizedDescription)")
        }
    }

    func fetchReviews(forBusiness businessId: String) {
        db.collection(FilePathString.business.filePathText).document(businessId).collection(FilePathString.reviews.filePathText)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching reviews: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                self.reviews = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Review.self)
                }
            }
    }
}
