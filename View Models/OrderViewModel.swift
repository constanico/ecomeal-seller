//
//  OrderViewModel.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 06/11/23.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class OrderViewModel: ObservableObject {
    private var db = Firestore.firestore()
    
    @Published var orders: [Order] = []
    @Published var orderItems: [OrderItem] = []
    
    init() {
        if let userId = Auth.auth().currentUser?.uid {
            fetchOrders(orderSellerId: userId)
        }
    }
}

// ORDER

extension OrderViewModel{
    
    func getUserId() -> String{
        let userId = Auth.auth().currentUser?.uid
        return userId ?? UUID().uuidString
    }
    
    func fetchOrders(orderSellerId: String) {
        db.collection(FilePathString.orders.filePathText)
            .whereField("orderSellerId", isEqualTo: orderSellerId)
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error fetching orders: \(error)")
                    return
                }
                
                if let snapshot = snapshot {
                    var ordersWithItems: [Order] = []

                    let dispatchGroup = DispatchGroup()

                    for document in snapshot.documents {
                        dispatchGroup.enter()

                        do {
                            var order = try document.data(as: Order.self)

                            let orderId = document.documentID
                            self.fetchOrderItems(forOrderId: orderId) { orderItems in
                                order.orderItems = orderItems
                                ordersWithItems.append(order)
                                dispatchGroup.leave()
                            }
                        } catch {
                            print("Error decoding order: \(error)")
                            dispatchGroup.leave()
                        }
                    }

                    dispatchGroup.notify(queue: .main) {
                        self.orders = ordersWithItems.sorted(by: { $0.orderTimestamp > $1.orderTimestamp })
                    }
                }
            }
    }


    
    func getTotalPrice() -> Float {
        let totalPrice = orderItems.reduce(0.0) { (result, item) in
            return result + item.itemNewPrice * Float(item.itemQuantity)
        }
        return totalPrice
    }
    
    func getTotalWeightSaved() -> Int{
        let totalWeight = orders.filter{
            $0.orderStatus == OrderStatusString.orderFinished.orderStatusText ||
            $0.orderStatus == OrderStatusString.orderReviewed.orderStatusText
        }
            .reduce(0){ (result, item) in
                return result + item.orderTotalWeight
            }
        
        return totalWeight
    }
    
    func getMoneyEarnedTotal() -> Float{
        let totalMoneySaved = orders.filter{
            $0.orderStatus == OrderStatusString.orderFinished.orderStatusText ||
            $0.orderStatus == OrderStatusString.orderReviewed.orderStatusText
        }
            .reduce(0.0){ (result, item) in
                return result + item.orderTotal
            }
        
        return totalMoneySaved
        
    }
    
    func getTotalMoneyEarnedForMonth(year: Int, month: Int) -> Float {
        let totalMoneySavedForMonth = orders
            .filter { order in
                if let (orderYear, orderMonth) = getMonthAndYearFromString(from: order.orderTimestamp) {
                    return orderYear == year && orderMonth == month
                }
                return false
            }
            .filter { $0.orderStatus == OrderStatusString.orderFinished.orderStatusText ||
                      $0.orderStatus == OrderStatusString.orderReviewed.orderStatusText }
            .reduce(0.0) { result, item in
                return result + item.orderTotal
            }
        
        return totalMoneySavedForMonth
    }
    
    func addOrder(uuid: String?, order: Order, orderItems: [OrderItem]) {
        do {
            
            let customDocumentID = uuid ?? UUID().uuidString
            var orderWithCustomID = order
            orderWithCustomID.id = customDocumentID
            
            try db.collection(FilePathString.orders.filePathText).document(customDocumentID).setData(from: orderWithCustomID)
            
            for orderItem in orderItems {
                try db.collection(FilePathString.orders.filePathText).document(customDocumentID).collection(FilePathString.orders.filePathText).addDocument(from: orderItem)
            }
            
            print("Order added successfully")
        } catch {
            print("Error adding order: \(error)")
        }
    }
    
    func updateOrderStatus(orderId: String, newStatus: String) {
        let orderDocument = db.collection(FilePathString.orders.filePathText).document(orderId)
        orderDocument.updateData(["orderStatus": newStatus]) { error in
            if let error = error {
                print("Error updating order status: \(error)")
            }
        }
    }
    
    func giveCashbackToCustomer(customerId: String, cashbackAmount: Float){
        let customerDocument = db.collection(FilePathString.users.filePathText).document(customerId)
        customerDocument.updateData(["ecoPoints": FieldValue.increment(Double(cashbackAmount))]){ error in
            if let error = error{
                print("Error giving cashback to customer: \(error)")
            }else{
                print("Cashback given to customer successfully.")
            }
        }
    }
    
    func giveRefundToCustomer(customerId: String, ecoPayAmount: Float){
        let customerDocument = db.collection(FilePathString.users.filePathText).document(customerId)
        customerDocument.updateData(["ecoPayBalance": FieldValue.increment(Double(ecoPayAmount))]){ error in
            if let error = error{
                print("Error giving EcoPay refund to customer: \(error)")
            }else{
                print("EcoPay refund given to customer successfully.")
            }
        }
    }
    
}

// INDIVIDUAL ITEM PER ORDER

extension OrderViewModel{
    
    func fetchOrderItems(forOrderId orderId: String?, completion: @escaping ([OrderItem]) -> Void) {
        if let orderId = orderId {
            db.collection(FilePathString.orders.filePathText).document(orderId)
                .collection(FilePathString.orders.filePathText)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error fetching order items: \(error)")
                        completion([])
                    } else {
                        let orderItems = querySnapshot?.documents.compactMap { document in
                            do {
                                return try document.data(as: OrderItem.self)
                            } catch {
                                print("Error decoding order item: \(error)")
                                return nil
                            }
                        }
                        completion(orderItems ?? [])
                    }
                }
        } else {
            completion([])
        }
    }

}




