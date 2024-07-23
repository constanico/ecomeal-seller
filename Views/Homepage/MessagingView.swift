//
//  MessagingView.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 26/11/23.
//

import SwiftUI
import FirebaseAuth

struct MessagingView: View {
    @StateObject var messageViewModel = MessagingViewModel()
    @StateObject var userViewModel = UserViewModel()
    @Binding var order: Order
    @State private var messageField = ""
    @Environment(\.presentationMode) var presentationMode
        
    var body: some View {
        NavigationView {
            ZStack {
                Color(ColorString.lightGreen.colorText)
                    .ignoresSafeArea()
                
                VStack {
                    ScrollView {
                        ScrollViewReader { proxy in
                            VStack {
                                ForEach(messageViewModel.messages.indices, id: \.self) { index in
                                    let message = messageViewModel.messages[index]
                                    HStack {
                                        if message.senderID == Auth.auth().currentUser?.uid {
                                            Spacer()
                                            VStack(alignment: .trailing) {
                                                MessageBubble(message: message.text, textColor: .white, bubbleColor: .green)
                                                Text("\(getTimeString(date: message.timestamp))\(message.isRead ? " • Read" : "")")
                                                    .font(.caption)
                                                    .opacity(0.5)
                                            }.padding(.leading, 30)
                                        } else {
                                            VStack(alignment: .leading) {
                                                MessageBubble(message: message.text, textColor: .black, bubbleColor: .white)
                                                Text("\(getTimeString(date: message.timestamp))")
                                                    .font(.caption)
                                                    .opacity(0.5)
                                            }.padding(.trailing, 30)
                                                .onAppear{
                                                    if !message.isRead{
                                                        messageViewModel.markMessageAsRead(orderId: order.id ?? "1", messageID: message.id ?? "1")
                                                    }
                                                }
                                            Spacer()
                                        }
                                    }
                                }
                                .onChange(of: messageViewModel.messages) { _ in
                                    withAnimation {
                                        proxy.scrollTo(messageViewModel.messages.count - 1, anchor: .bottom)
                                    }
                                }
                            }
                            .padding()
                            .onAppear {
                                messageViewModel.fetchMessages(orderId: order.id ?? "1")
                            }
                        }
                    }
                    
                    if order.orderStatus != OrderStatusString.orderFinished.orderStatusText && order.orderStatus != OrderStatusString.orderReviewed.orderStatusText && order.orderStatus != OrderStatusString.orderCancelled.orderStatusText{
                        HStack {
                            TextField("Send message...", text: $messageField)
                                .cornerRadius(50)
                                .textFieldStyle(OvalTextFieldStyle())
                                .shadow(color: .black.opacity(0.2), radius: 2, y: 2)
                            Button(action: {
                                sendMessage()
                            }) {
                                Image(systemName: "paperplane.fill")
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                                    .background(.green)
                                    .cornerRadius(50)
                            }
                            .disabled(messageField.isEmpty)
                            .opacity(messageField.isEmpty ? 0.3 : 1)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }else{
                        Text("Order has been completed. You can no longer send messages.")
                            .font(.footnote)
                            .bold()
                            .opacity(0.5)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle(order.orderUserName)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton(onButtonTap: { presentationMode.wrappedValue.dismiss() })
                }
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
        )
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    func sendMessage() {
        messageViewModel.sendMessage(orderId: order.id ?? "1", text: messageField, senderID: Auth.auth().currentUser?.uid ?? "1", receiverID: order.orderUserId)
        messageViewModel.fetchMessages(orderId: order.id ?? "1")
        messageField = ""
    }
}



#Preview {
    MessagingView(order: .constant(orderDummy))
}
