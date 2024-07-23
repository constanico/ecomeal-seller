//
//  CustomRowView.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 28/10/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct CustomRowView: View {
    var imageUrl: String
    var title: String
    var subtitle: String?
    var description: String
    var starRating: Double?
    var totalPrice: Float?
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.2), radius: 7.5, y: 5)
            
            VStack(alignment: .leading){
                HStack{
                    VStack{
                        WebImage(url: URL(string: imageUrl))
                            .resizable()
                            .placeholder(Image(systemName: "photo"))
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                            .padding(.trailing, 8)
                        if starRating != nil{
                            HStack{
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                if starRating ?? 0 > 0{
                                    Text(String(format: "%.1f", starRating ?? 0))
                                        .foregroundColor(.black).bold().padding(.horizontal, -5)
                                }else{
                                    Text("-")
                                    
                                        .foregroundColor(.black)
                                        .padding(.horizontal, -5)
                                }
                            }.padding(.vertical, 5)
                        }
                    }
                    
                    VStack(alignment: .leading){
                        HStack{
                            VStack(alignment: .leading){
                                Text(title)
                                    .bold()
                                    .foregroundColor(.black)
                                
                                if subtitle != nil{
                                    Text(subtitle ?? "")
                                        .foregroundColor(.black.opacity(0.5))
                                }
                            }
                                Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .opacity(0.5)
                            
                            
                        }.padding(.horizontal)
                            .padding(.top, 15)
                        
                        Divider()
                            .background(Color.gray)
                            .frame(height: 1)
                            .padding(.horizontal)
                        
                        Text("\(description)")
                            .foregroundColor(.gray)
                            .foregroundColor(.black)
                            .padding(.vertical, 5)
                            .padding(.horizontal)
                        
                        if let totalPrice = totalPrice{
                            HStack{
                                Spacer()
                                Text("Rp " + (formatNumber(Double(totalPrice)) ?? "0"))
                                    .font(.title3)
                                    .bold()
                            }.padding(.horizontal)
                        }
                        
                    }.padding(.bottom, 15)
                }.padding(.horizontal, 20)
            }
            Spacer()
        }
    }
}

#Preview {
    CustomRowView(
        imageUrl: "yourImageUrlString",
        title: "iPhone",
        subtitle: "Open",
        description: "At Apple Park",
        starRating: 5.0,
        totalPrice: 30000
    )
}

