//
//  BusinessItemViewModel.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 28/10/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class ItemViewModel: ObservableObject {
    @Published var items: [BusinessItem] = []
    @Published var currBusinessId: String = "1"
    private var db = Firestore.firestore()
    
 

    func fetchItems(forBusiness businessId: String) {
        db.collection(FilePathString.business.filePathText).document(businessId)
            .collection(FilePathString.businessItems.filePathText).addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching items: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            self.items = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: BusinessItem.self)
            }
        }
    }
    
    func addItem(toBusiness businessId: String, item: BusinessItem, image: UIImage?) {
        do {
            let docRef = try db.collection(FilePathString.business.filePathText).document(businessId).collection(FilePathString.businessItems.filePathText).addDocument(from: item)

            if let image = image {
                if let imageData = image.jpegData(compressionQuality: 0.25) ?? image.pngData() {
                    uploadItemImage(imageData: imageData, forItemId: docRef.documentID) { result in
                        switch result {
                        case .success(let imageUrl):
                            docRef.updateData(["imageUrl": imageUrl]) { error in
                                if let error = error {
                                    print("Error updating item imageUrl: \(error.localizedDescription)")
                                } else {
                                    print("Item imageUrl updated successfully")
                                }
                            }
                            print("Item added successfully")
                        case .failure(let error):
                            print("Error uploading item image: \(error.localizedDescription)")
                        }
                    }
                } else {
                    print("Error converting item image or uploading item image")
                }
            } else {
                print("Item added successfully")
            }
        } catch {
            print("Error adding item: \(error.localizedDescription)")
        }
    }
    
    func updateItemIsListed(item: BusinessItem, isListed: Bool) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].itemIsListed = isListed

            let itemRef = db.collection(FilePathString.business.filePathText)
                .document(currBusinessId)
                .collection(FilePathString.businessItems.filePathText)
                .document(item.id ?? "")

            itemRef.updateData(["itemIsListed": isListed]) { error in
                if let error = error {
                    print("Error updating itemIsListed status: \(error.localizedDescription)")
                } else {
                    print("ItemIsListed status updated successfully.")
                }
            }
        }
    }
    
    func editItem(_ item: BusinessItem, newItemData: BusinessItem, newImage: UIImage?) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = newItemData

            let itemRef = db.collection(FilePathString.business.filePathText)
                .document(currBusinessId)
                .collection(FilePathString.businessItems.filePathText)
                .document(item.id ?? "")

            do {
                try itemRef.setData(from: newItemData)
                print("Item updated successfully")

                if let image = newImage {
                    if let imageData = image.jpegData(compressionQuality: 0.25) ?? image.pngData() {
                        uploadItemImage(imageData: imageData, forItemId: item.id ?? "") { result in
                            switch result {
                            case .success(let imageUrl):
                                itemRef.updateData(["imageUrl": imageUrl]) { error in
                                    if let error = error {
                                        print("Error updating item image URL: \(error.localizedDescription)")
                                    } else {
                                        print("Item image updated successfully")
                                    }
                                }
                            case .failure(let error):
                                print("Error uploading item image: \(error.localizedDescription)")
                            }
                        }
                    } else {
                        print("Error converting item image or uploading item image")
                    }
                }
            } catch {
                print("Error updating item: \(error.localizedDescription)")
            }
        }
    }

    
    func deleteItem(_ item: BusinessItem) {
        if let index = items.firstIndex(where: { $0.itemId == item.itemId }) {
            items.remove(at: index)

            let itemRef = db.collection(FilePathString.business.filePathText)
                .document(currBusinessId)
                .collection(FilePathString.businessItems.filePathText)
                .document(item.id ?? "")

            itemRef.delete { error in
                if let error = error {
                    print("Error deleting item: \(error.localizedDescription)")
                } else {
                    print("Item deleted successfully")

                    let imageRef = Storage.storage().reference().child("item_images/\(item.id ?? "").jpg")
                    imageRef.delete { error in
                        if let error = error {
                            print("Error deleting item image: \(error.localizedDescription)")
                        } else {
                            print("Item image deleted successfully")
                        }
                    }
                }
            }
        }
    }


}

extension ItemViewModel {
    func uploadItemImage(imageData: Data, forItemId itemId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let imageRef = Storage.storage().reference().child("item_images/\(itemId).jpg")
        
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
                    completion(.failure(NSError(domain: "AppError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Item Image URL not found"])))
                }
            }
        }
    }
}
