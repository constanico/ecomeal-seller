//
//  OrderView.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 14/11/23.
//

import SwiftUI

struct OrderView: View {
    @StateObject var orderViewModel = OrderViewModel()
    
    //Order categories
    var pendingOrders: [Order] {
        return orderViewModel.orders.filter {
            $0.orderStatus == OrderStatusString.orderPending.orderStatusText
        }
    }
    
    var ongoingOrders: [Order] {
        return orderViewModel.orders.filter {
            $0.orderStatus == OrderStatusString.orderOngoing.orderStatusText
        }
    }
    
    var readyOrders: [Order] {
        return orderViewModel.orders.filter {
            $0.orderStatus == OrderStatusString.orderReadyForPickup.orderStatusText
        }
    }
    
    var orderHistory: [Order] {
        return orderViewModel.orders.filter {
            $0.orderStatus == OrderStatusString.orderFinished.orderStatusText ||
            $0.orderStatus == OrderStatusString.orderCancelled.orderStatusText ||
            $0.orderStatus == OrderStatusString.orderReviewed.orderStatusText
        }
    }
    
    let segments = ["Ongoing Orders", "History"]
    @State private var selectedIndex = 0
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(ColorString.lightGreen.colorText)
                VStack{
                    HStack{
                        Picker(selection: $selectedIndex, label: Text("Segments")) {
                            ForEach(0..<segments.count) { index in
                                
                                Text(self.segments[index])
                                    .foregroundColor(.black)
                                    .tag(index)
                                
                            }
                        }
                        .frame(width: 180, height: 40)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(50)
                        Spacer()
                        
                    }.padding(.horizontal)
                        .padding(.top)
                    ScrollView{
                        if !ongoingOrders.isEmpty && selectedIndex == 0{
                            VStack{
                                HStack{
                                    Image(systemName: "clock")
                                        .bold()
                                    Text("Ongoing orders")
                                        .bold()
                                    Spacer()
                                }.padding(.horizontal)
                                ForEach(ongoingOrders, id: \.self) { item in
                                    NavigationLink(destination: OrderDetailView(order: item)) {
                                        
                                        OrderRowView(
                                            imageUrl: item.imageUrl ?? "",
                                            title: item.orderUserName, subTitle: item.orderBusinessName,
                                            orderInfo: "\(String(describing: item.orderItems?.reduce(0) { $0 + $1.itemQuantity } ?? 0)) items ordered", orderStatus: item.orderStatus, onAccept: {
                                            orderViewModel.updateOrderStatus(orderId: item.id ?? "1", newStatus: OrderStatusString.orderOngoing.orderStatusText)
                                        }, onDeny: {
                                            if item.orderPaymentMethod == "EcoPay"{
                                                orderViewModel.giveRefundToCustomer(customerId: item.orderUserId, ecoPayAmount: item.orderTotal + fixedPlatformFee)
                                            }else if item.orderPaymentMethod == "EcoPoints"{
                                                orderViewModel.giveCashbackToCustomer(customerId: item.orderSellerId, cashbackAmount: item.orderTotal + fixedPlatformFee)
                                            }
                                            orderViewModel.updateOrderStatus(orderId: item.id ?? "1", newStatus: OrderStatusString.orderCancelled.orderStatusText)
                                        })
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 2.5)
                                    
                                }.buttonStyle(PlainButtonStyle())
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }.padding(.top, 20)
                                .padding(.bottom, 30)
                        }
                        
                        if !readyOrders.isEmpty && selectedIndex == 0{
                            VStack{
                                HStack{
                                    Image(systemName: "hand.raised.circle")
                                        .bold()
                                    Text("Orders ready for pickup")
                                        .bold()
                                    Spacer()
                                }.padding(.horizontal)
                                ForEach(readyOrders, id: \.self) { item in
                                    NavigationLink(destination: OrderDetailView(order: item)) {
                                        
                                        OrderRowView(imageUrl: item.imageUrl ?? "", title: item.orderUserName, subTitle: item.orderBusinessName, orderInfo: "\(String(describing: item.orderItems?.reduce(0) { $0 + $1.itemQuantity } ?? 0)) items ordered", orderStatus:  item.orderStatus, onAccept: {
                                            orderViewModel.updateOrderStatus(orderId: item.id ?? "1", newStatus: OrderStatusString.orderOngoing.orderStatusText)
                                        }, onDeny: {
                                            orderViewModel.updateOrderStatus(orderId: item.id ?? "1", newStatus: OrderStatusString.orderCancelled.orderStatusText)
                                        })
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 2.5)
                                    
                                }.buttonStyle(PlainButtonStyle())
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }.padding(.top, 20)
                                .padding(.bottom, 30)
                        }
                        
                        if !pendingOrders.isEmpty && selectedIndex == 0{
                            VStack{
                                HStack{
                                    Image(systemName: "ellipsis.circle")
                                        .bold()
                                    Text("Pending orders")
                                        .bold()
                                    Spacer()
                                }.padding(.horizontal)
                                ForEach(pendingOrders, id: \.self) { item in
                                    NavigationLink(destination: OrderDetailView(order: item)) {
                                        
                                        OrderRowView(imageUrl: item.imageUrl ?? "", title: item.orderUserName, subTitle: item.orderBusinessName, orderInfo: "\(String(describing: item.orderItems?.reduce(0) { $0 + $1.itemQuantity } ?? 0)) items ordered", orderStatus: item.orderStatus, onAccept: {
                                            orderViewModel.updateOrderStatus(orderId: item.id ?? "1", newStatus: OrderStatusString.orderOngoing.orderStatusText)
                                        }, onDeny: {
                                            orderViewModel.updateOrderStatus(orderId: item.id ?? "1", newStatus: OrderStatusString.orderCancelled.orderStatusText)
                                        })
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 2.5)
                                    
                                }.buttonStyle(PlainButtonStyle())
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }.padding(.top, 20)
                                .padding(.bottom, 30)
                        }
                        
                        if !orderHistory.isEmpty && selectedIndex == 1{
                            VStack{
                                HStack{
                                    Image(systemName: "checkmark.circle")
                                        .bold()
                                    Text("Finished orders")
                                        .bold()
                                    Spacer()
                                }.padding(.horizontal)
                                ForEach(orderHistory, id: \.self) { item in
                                    NavigationLink(destination: OrderDetailView(order: item)) {
                                        
                                        OrderRowView(imageUrl: item.imageUrl ?? "", title: item.orderUserName, subTitle: item.orderBusinessName, orderInfo: "\(String(describing: item.orderItems?.reduce(0) { $0 + $1.itemQuantity } ?? 0)) items ordered", orderStatus: item.orderStatus == OrderStatusString.orderFinished.orderStatusText ? "Order finished" : item.orderStatus, onAccept: {
                                            orderViewModel.updateOrderStatus(orderId: item.id ?? "1", newStatus: OrderStatusString.orderOngoing.orderStatusText)
                                        }, onDeny: {
                                            orderViewModel.updateOrderStatus(orderId: item.id ?? "1", newStatus: OrderStatusString.orderCancelled.orderStatusText)
                                        })
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 2.5)
                                    
                                }.buttonStyle(PlainButtonStyle())
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }.padding(.top, 20)
                                .padding(.bottom, 30)
                        }
                        
                        
                    }

                }.padding(.bottom, 50)
                if pendingOrders.isEmpty && ongoingOrders.isEmpty && readyOrders.isEmpty && selectedIndex == 0{
                    VStack{
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                        
                        Text("No orders have been made yet")
                            .bold()
                            .foregroundColor(.gray)
                            .padding()
                        
                    }
                }
            }.navigationTitle("Orders")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle("ECOMEAL Seller")
                .navigationBarBackButtonHidden(true)
                .toolbarBackground(
                    Color(ColorString.lightGreen.colorText),
                    for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .edgesIgnoringSafeArea(.bottom)
            
        }
    }
}

#Preview {
    OrderView()
}

