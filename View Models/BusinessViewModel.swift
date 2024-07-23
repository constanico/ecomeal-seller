//
//  BusinessViewModel.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 28/10/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class BusinessViewModel: ObservableObject {
    @Published var businesses: [Business] = []
    private var db = Firestore.firestore()
    
    init(){
        fetchBusinesses(sellerId: Auth.auth().currentUser?.uid ?? "")
    }
    
    func getBusinessName(fromId: String) -> String{
        if let targetBusiness = businesses.first(where: { $0.businessId == fromId }) {
            let businessName = targetBusiness.businessName
            return businessName
        } else {
            print("Business with businessId '\(fromId)' not found.")
            return "0"
        }
    }

    
    func fetchBusinesses(sellerId: String) {
        db.collection(FilePathString.business.filePathText).whereField("businessSellerId", isEqualTo: sellerId)
            .addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching businesses: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            self.businesses = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: Business.self)
            }
        }
    }
    
    
    
    func addBusiness(uuid: String, business: Business, image: UIImage?) {
        do {
            let customDocumentID = uuid
            var businessWithCustomID = business
            businessWithCustomID.id = customDocumentID

            try db.collection(FilePathString.business.filePathText).document(customDocumentID).setData(from: businessWithCustomID)

            if let image = image {
                if let imageData = image.jpegData(compressionQuality: 0.25) ?? image.pngData() {
                    uploadBusinessImage(imageData: imageData, forBusinessId: customDocumentID) { result in
                        switch result {
                        case .success(let imageUrl):
                            let businessRef = self.db.collection(FilePathString.business.filePathText).document(customDocumentID)
                            businessRef.updateData(["imageUrl": imageUrl]) { error in
                                if let error = error {
                                    print("Error updating imageUrl: \(error.localizedDescription)")
                                } else {
                                    print("ImageUrl updated successfully")
                                }
                            }

                            if let index = self.businesses.firstIndex(where: { $0.businessId == customDocumentID }) {
                                self.businesses[index] = businessWithCustomID
                            }

                            print("Business added successfully")
                        case .failure(let error):
                            print("Error uploading image: \(error.localizedDescription)")
                        }
                    }
                } else {
                    print("Error converting image or uploading image")
                }
            } else {
                print("Business added successfully")
            }
        } catch {
            print("Error adding business: \(error.localizedDescription)")
        }
    }
    
    func updateBusinessOpenStatus(businessId: String, isOpen: Bool) {
        let businessRef = db.collection(FilePathString.business.filePathText).document(businessId)
        
        businessRef.updateData(["businessIsOpen": isOpen]) { error in
            if let error = error {
                print("Error updating business open status: \(error.localizedDescription)")
            } else {
                print("Business open status updated successfully.")
            }
        }
    }

    func updateBusinessRating(businessId: String, newRating: Double) {
        let businessRef = db.collection(FilePathString.business.filePathText).document(businessId)
        
        businessRef.updateData(["businessRating": newRating]) { error in
            if let error = error {
                print("Error updating business rating: \(error.localizedDescription)")
            } else {
                print("Business rating updated successfully.")
            }
        }
    }
    
    func editBusiness(businessId: String, updatedBusiness: Business, updatedImage: UIImage?) {
        do {
            let businessRef = db.collection(FilePathString.business.filePathText).document(businessId)

            try businessRef.setData(from: updatedBusiness, merge: true) { error in
                if let error = error {
                    print("Error updating business: \(error.localizedDescription)")
                } else {
                    print("Business updated successfully")
                }

                if let updatedImage = updatedImage {
                    if let imageData = updatedImage.jpegData(compressionQuality: 0.25) ?? updatedImage.pngData() {
                        self.uploadBusinessImage(imageData: imageData, forBusinessId: businessId) { result in
                            switch result {
                            case .success(let imageUrl):
                                businessRef.updateData(["imageUrl": imageUrl]) { error in
                                    if let error = error {
                                        print("Error updating imageUrl: \(error.localizedDescription)")
                                    } else {
                                        print("ImageUrl updated successfully")
                                    }
                                }
                            case .failure(let error):
                                print("Error uploading image: \(error.localizedDescription)")
                            }
                        }
                    } else {
                        print("Error converting image or uploading image")
                    }
                }
            }
        } catch {
            print("Error editing business: \(error.localizedDescription)")
        }
    }
    
    func deleteBusiness(businessId: String) {
        let businessRef = db.collection(FilePathString.business.filePathText).document(businessId)

        businessRef.delete { [self] error in
            if let error = error {
                print("Error deleting business: \(error.localizedDescription)")
            } else {
                deleteBusinessImage(businessId: businessId)
            }
        }
        
        let imageRef = Storage.storage().reference().child("business_images/\(businessId).jpg")

        imageRef.delete { error in
            if let error = error {
                print("Error deleting business image: \(error.localizedDescription)")
            } else {
            }
        }
    }

    func deleteBusinessImage(businessId: String) {
        let imageRef = Storage.storage().reference().child("business_images/\(businessId).jpg")

        imageRef.delete { error in
            if let error = error {
                print("Error deleting business image: \(error.localizedDescription)")
            } else {
            }
        }
    }

    
}

extension BusinessViewModel{

    func uploadBusinessImage(imageData: Data, forBusinessId businessId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let imageRef = Storage.storage().reference().child("business_images/\(businessId).jpg")
        
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            imageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let imageUrl = url?.absoluteString {
                    completion(.success(imageUrl))
                } else {
                    completion(.failure(NSError(domain: "AppError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Image URL not found"])))
                }
            }
        }
    }

}

