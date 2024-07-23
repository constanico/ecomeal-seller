//
//  OrderRowView.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 17/11/23.
//

import SwiftUI

import SwiftUI
import SDWebImageSwiftUI

struct OrderRowView: View {
    var imageUrl: String
    var title: String
    var subTitle: String
    var orderInfo: String
    var orderStatus: String
    var totalPrice: Float?
    var onAccept: () -> Void
    var onDeny: () -> Void
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.2), radius: 7.5, y: 5)
            
            VStack(alignment: .leading){
                HStack{
                    
                    VStack{
                        HStack{
                            WebImage(url: URL(string: imageUrl))
                                .resizable()
                                .placeholder(Image(systemName: "photo"))
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)
                                .padding(.trailing, 8)
                            VStack(alignment: .leading){
                                Text(title)
                                    .bold()
                                    .foregroundColor(.black)
                                Text(subTitle)
                                    .bold()
                                    .opacity(0.4)
                                
                            }
                                Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .opacity(0.5)
                            
                            
                        }.padding(.top, 15)
                    
                        HStack{
                            Text("\(orderInfo)")
                                .foregroundColor(.gray)
                                .padding(.vertical, 5)
                                .padding(.bottom, 10)
                            Spacer()
                        }
                        
                        HStack{
                            Spacer()
                            Image(systemName: "clock")
                                .bold()
                            Text("\(orderStatus)")
                                .bold()
                                .foregroundColor(.black)
                            Spacer()
                                
                        }
                        
                        if orderStatus == OrderStatusString.orderPending.orderStatusText{
                            VStack{
                                HStack{
                                    Button(action: {
                                        onAccept()
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
                                        onDeny()
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
                                }.padding(.bottom, 5)
                                Text("Accept order to continue with transaction.")
                                    .font(.footnote).opacity(0.4)
                            }.padding()
                        }
                        
                        
                        
                    }.padding(.bottom, 15)
                }.padding(.horizontal, 20)
            }
            Spacer()
        }
    }
}

#Preview {
    OrderRowView(
        imageUrl: "yourImageUrlString",
        title: "Mike Dane",
        subTitle: "Joe's Resto",
        orderInfo: "3 items ordered",
        orderStatus: OrderStatusString.orderPending.orderStatusText,
        totalPrice: 30000,
        onAccept: {},
        onDeny: {}
    )
}

