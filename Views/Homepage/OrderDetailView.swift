//
//  OrderDetailView.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 17/11/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct OrderDetailView: View {
    @State var order: Order
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var orderViewModel = OrderViewModel()
    @StateObject var messagingViewModel = MessagingViewModel()
    @StateObject var userViewModel = UserViewModel()
    
    @State private var isAlertForCancelOrderShown = false
    @State private var isQRCodeSheetPresented = false
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(ColorString.lightGreen.colorText)
                    .ignoresSafeArea()
                VStack{
                ScrollView{
                    ZStack{
                        Rectangle()
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: Color.gray.opacity(0.3), radius: 5, y: 5)
                        
                        VStack(){
                            HStack{
                                WebImage(url: URL(string: order.imageUrl ?? ""))
                                    .resizable()
                                    .placeholder(Image(systemName: "photo"))
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)
                                    .padding(.trailing, 8)
                                VStack(alignment: .leading){
                                    Text("\(order.orderUserName)'s Order").bold()
                                    Text("Order ID: \(order.id ?? "Null")").opacity(0.5)
                                }
                                Spacer()
                                
                                if order.orderStatus == OrderStatusString.orderOngoing.orderStatusText || order.orderStatus == OrderStatusString.orderReadyForPickup.orderStatusText{
                                    Menu{
                                        Button(action: {
                                            isQRCodeSheetPresented.toggle()
                                        }) {
                                            Label("Show QR", systemImage: "qrcode")
                                        }
                                        Button(action: {
                                            isAlertForCancelOrderShown.toggle()
                                        }) {
                                            Label("Cancel Order", systemImage: "xmark")
                                        }
                                        
                                    } label: {
                                        Button(action: {
                                            isAlertForCancelOrderShown.toggle()
                                        }) {
                                            Image(systemName: "ellipsis")
                                                .bold()
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(.gray)
                                                .frame(width: 40, height: 40)
                                                .background(Color.black.opacity(0.05))
                                                .cornerRadius(50)
                                            
                                        }
                                    }.alert("Cancel this order? This cannot be undone.", isPresented: $isAlertForCancelOrderShown) {
                                        Button("Cancel Order", role: .destructive) {
                                            cancelOrder()
                                        }
                                        Button("Nevermind", role: .cancel) { }
                                    }
                                    
                                }
                            }.padding()
                            
                            ZStack{
                                Rectangle()
                                    .foregroundColor(.black.opacity(0.05))
                                    .frame(height: 80)
                                    .cornerRadius(10)
                                HStack{
                                    Image(systemName: "fork.knife")
                                        .resizable()
                                        .frame(width: 20, height: 27)
                                        .opacity(0.5)
                                        .padding(.horizontal)
                                    VStack(alignment: .leading){
                                        
                                        Text("Order Status").opacity(0.3)
                                        Text("\(order.orderStatus == OrderStatusString.orderFinished.orderStatusText ? "Order finished" :  order.orderStatus)").bold()
                                    }
                                    
                                }
                            }
                            
                            
                            
                            if order.orderStatus == OrderStatusString.orderPending.orderStatusText{
                                VStack{
                                    HStack{
                                        Button(action: {
                                            updateOrderStatus(newOrderStatus: OrderStatusString.orderOngoing.orderStatusText)
                                        }) {
                                            HStack{
                                                Image(systemName: "checkmark")
                                                    .bold()
                                                    .foregroundColor(.green)
                                                
                                                Text("Accept")
                                                    .foregroundColor(.green)
                                                    .bold()
                                            }.frame(width: 120, height: 50)
                                                .background(Color.green.opacity(0.2))
                                                .cornerRadius(50)
                                            
                                        }
                                        
                                        Button(action: {
                                            cancelOrder()
                                        }) {
                                            HStack{
                                                Image(systemName: "xmark")
                                                    .bold()
                                                    .foregroundColor(.red)
                                                
                                                Text("Deny")
                                                    .foregroundColor(.red)
                                                    .bold()
                                                
                                            }.frame(width: 120, height: 50)
                                                .background(Color.red.opacity(0.2))
                                                .cornerRadius(50)
                                        }
                                    }.padding(.top)
                                    Text("Accept order to continue with transaction.")
                                        .font(.footnote).opacity(0.4)
                                }
                            }else if order.orderStatus == OrderStatusString.orderOngoing.orderStatusText{
                                VStack{
                                    HStack{
                                        Button(action: {
                                            updateOrderStatus(newOrderStatus: OrderStatusString.orderReadyForPickup.orderStatusText)
                                        }) {
                                            HStack{
                                                Image(systemName: "arrow.up")
                                                    .bold()
                                                    .foregroundColor(.green)
                                                
                                                Text("Update Status")
                                                    .foregroundColor(.green)
                                                    .bold()
                                            }.frame(width: 200, height: 50)
                                                .background(Color.green.opacity(0.2))
                                                .cornerRadius(50)
                                            
                                        }
                                        
                                    }.padding(.top)
                                    Text("Update to Ready for Pickup")
                                        .font(.footnote).opacity(0.4)
                                }
                            }else if order.orderStatus == OrderStatusString.orderReadyForPickup.orderStatusText{
                                VStack{
                                    HStack{
                                        Button(action: {
                                            updateOrderStatus(newOrderStatus: OrderStatusString.orderFinished.orderStatusText)
                                        }) {
                                            HStack{
                                                Image(systemName: "checkmark.circle")
                                                    .bold()
                                                    .foregroundColor(.green)
                                                
                                                Text("Finish Order")
                                                    .foregroundColor(.green)
                                                    .bold()
                                            }.frame(width: 200, height: 50)
                                                .background(Color.green.opacity(0.2))
                                                .cornerRadius(50)
                                            
                                        }
                                        
                                    }.padding(.top)
                                    Text("Wait for customer to pick up order.")
                                        .font(.footnote).opacity(0.4)
                                }
                            }
                            Text("Ordered on: \(order.orderTimestamp)")
                                .foregroundColor(.black.opacity(0.4))
                                .bold()
                                .font(.footnote)
                                .padding(.top)
                        }.padding()
                        
                    }.padding(.horizontal, 10)
                        .padding(.top, 20)
                    
                    
                    
                    ZStack{
                        Rectangle()
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: Color.gray.opacity(0.3), radius: 5, y: 5)
                        
                        
                        VStack{
                            Text("What They Ordered").bold()
                            Divider()
                                .background(Color.gray)
                                .frame(height: 1)
                                .padding(.horizontal)
                            ForEach(order.orderItems ?? [orderItemDummy], id: \.self) { item in
                                HStack{
                                    Text("•")
                                    VStack(alignment: .leading){
                                        Text("\(item.itemName) (\(item.itemQuantity))")
                                        Text("\(currencyString)\(formatNumber(Double(item.itemNewPrice * Float(item.itemQuantity))) ?? "0")").opacity(0.5)
                                    }
                                    Spacer()
                                }.padding(5)
                                
                            }.padding(.horizontal, 5)
     
                            HStack{
                                Spacer()
                                Text("Total: \(currencyString)\(formatNumber(Double(order.orderTotal)) ?? "0")")
                                    .font(.headline)
                            }.padding()
                            Divider()
                                .background(.gray)
                            
                            HStack{
                                Text("Payment Method")
                                Spacer()
                                Text(order.orderPaymentMethod)
                                    .font(.headline)
                            }.padding(.horizontal)
                                .padding(.vertical, 10)
        
                        }.padding()
                        
                    }.padding(10)
                }

                        NavigationLink(destination: MessagingView(order: $order)) {
                            HStack {
                                Image(systemName: "bubble.fill")
                                    .bold()
                                    .foregroundColor(.green)
                                
                                Text(order.orderStatus == OrderStatusString.orderFinished.orderStatusText || order.orderStatus == OrderStatusString.orderReviewed.orderStatusText || order.orderStatus == OrderStatusString.orderCancelled.orderStatusText ? "View Message History" : "Message Customer")
                                    .foregroundColor(.green)
                                    .bold()
                        
                                if messagingViewModel.countUnreadMessages() > 0{
                                    ZStack{
                                        ZStack {
                                            Circle()
                                                .frame(width: 30, height: 30)
                                                .foregroundColor(.red)
                                            if messagingViewModel.countUnreadMessages() < 10{ Text("\(messagingViewModel.countUnreadMessages())")
                                                    .bold()
                                                    .foregroundColor(.white)
                                            }else{
                                                Text("9+")
                                                    .bold()
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    }
                                }
                                
                            }
                            .frame(width: 300, height: 50)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(50)
                            .padding(.bottom)
                        }
                    
            }
                
            }.navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle("Manage Order")
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        BackButton(onButtonTap: { presentationMode.wrappedValue.dismiss()})
                    }
                }
                .sheet(isPresented: $isQRCodeSheetPresented){
                    QRCodeGeneratorView(dataString: order.id ?? "1")
                }
                .onAppear{
                    messagingViewModel.fetchMessages(orderId: order.id ?? "1")
                }
        }.navigationBarBackButtonHidden(true)
            .gesture(
                DragGesture()
                    .onEnded { gesture in
                        if gesture.translation.width > 100 {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
            )
        
        
    }
    
    func updateOrderStatus(newOrderStatus: String){
        orderViewModel.updateOrderStatus(orderId: order.id ?? "1", newStatus: newOrderStatus)
        
        if newOrderStatus == OrderStatusString.orderFinished.orderStatusText{
            orderViewModel.giveCashbackToCustomer(customerId: order.orderUserId, cashbackAmount: order.orderCashback)
            
            print("in here")
        }
    }
    
    func cancelOrder(){
        if order.orderPaymentMethod == "EcoPay"{
            orderViewModel.giveRefundToCustomer(customerId: order.orderUserId, ecoPayAmount: order.orderTotal + fixedPlatformFee)
        }else if order.orderPaymentMethod == "EcoPoints"{
            orderViewModel.giveCashbackToCustomer(customerId: order.orderSellerId, cashbackAmount: order.orderTotal + fixedPlatformFee)
        }
        updateOrderStatus(newOrderStatus: OrderStatusString.orderCancelled.orderStatusText)
    }
    
}

#Preview {
    OrderDetailView(order: orderDummy)
}
