//
//  FinanceView.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 21/11/23.
//

import SwiftUI

struct FinanceView: View {
    @StateObject var orderViewModel = OrderViewModel()
    var transactions: [Order] {
        return orderViewModel.orders.filter {
            $0.orderStatus == OrderStatusString.orderFinished.orderStatusText ||
            $0.orderStatus == OrderStatusString.orderReviewed.orderStatusText
        }
    }
    var body: some View {
        NavigationView{
            ZStack{
                Color(ColorString.lightGreen.colorText)
                    .ignoresSafeArea()
                ScrollView{
                    VStack{
                        ZStack{
                            Rectangle()
                                .foregroundColor(Color(ColorString.darkGreen.colorText))
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.25), radius: 3, y: 3)
                            
                            VStack{
                                HStack{
                                    Image(systemName: "dollarsign.circle")
                                        .foregroundColor(.white)
                                    Text("Your Earnings")
                                        .bold()
                                        .foregroundColor(.white)
                                    Spacer()
                                }.padding(10)
                                
                                VStack{
                                    ZStack{
                                        Rectangle()
                                            .foregroundColor(.white.opacity(0.1))
                                            .cornerRadius(10)
                                        HStack{
                                            Text("This month")
                                                .foregroundColor(.white)
                                            Spacer()
                                            Text("\(currencyString)\(formatNumber(Double(orderViewModel.getTotalMoneyEarnedForMonth(year: getCurrentYearAndMonth().year, month: getCurrentYearAndMonth().month))) ?? "0")")
                                                .bold()
                                                .font(.title2)
                                                .foregroundColor(.white)
                                            
                                        }.padding()
                                        
                                    }
                                    ZStack{
                                        Rectangle()
                                            .foregroundColor(.white.opacity(0.1))
                                            .cornerRadius(10)
                                        HStack{
                                            Text("All time")
                                                .foregroundColor(.white)
                                            Spacer()
                                            Text("\(currencyString)\(formatNumber(Double(orderViewModel.getMoneyEarnedTotal())) ?? "0")")
                                                .bold()
                                                .font(.title2)
                                                .foregroundColor(.white)
                                            
                                        }.padding()
                                        
                                    }
                                }
                                
                                
                            }.padding(20)
                            
                        }
                        
                        if transactions.count > 0{
                            HStack{
                                Image(systemName: "checkmark.circle")
                                Text("Transaction History")
                                Spacer()
                            }.padding()
                        }
                        
                        ForEach(transactions, id: \.self) { item in
                            NavigationLink(destination: OrderDetailView(order: item)) {
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .shadow(color: .black.opacity(0.15), radius: 3, y: 3)
                                    
                                    VStack{
                                        
                                        HStack{
                                            Image(systemName: "doc.text.fill")
                                                .foregroundStyle(Color.gray, Color.blue)
                                            VStack(alignment: .leading){
                                                Text("\(item.orderUserName)")
                                                    .bold()
                                                Text("\(item.orderBusinessName)")
                                                Text("\(item.orderTimestamp)")
                                                    .opacity(0.5)
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .opacity(0.2)
                                                .padding()
                                        }
                                        
                                        Divider()
                                            .background(Color.gray)
                                            .frame(height: 1)
                                            .padding(.horizontal)
                                        
                                        HStack{
                                            Text("Money earned")
                                                .bold()
                                            Spacer()
                                            Text("+ \(currencyString)\(formatNumber(Double(item.orderTotal)) ?? "0")")
                                                .bold()
                                        }.padding(.vertical, 5)
                                        
                                    }.padding()
                                    
                                }.padding(.vertical, 5)
                            }
                            
                        }.buttonStyle(PlainButtonStyle())
                        
                    }.padding()
                        .padding(.bottom, 80)
                    
                }
            }.navigationTitle("Finance")
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
    FinanceView()
}
