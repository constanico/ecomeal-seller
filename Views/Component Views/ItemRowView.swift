//
//  ItemRowView.swift
//  ECOMEAL
//
//  Created by Jason Leonardo on 12/10/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ItemRowView: View {
    var imageUrl: String?
    var uiImage: UIImage?
    var itemName: String
    var oldPrice: Float
    var newPrice: Float
    var quantity: Int
    var weight: Int
    var description: String
    var isListed: Bool?
    var onList: (() -> Void)?
    var onEdit: () -> Void
    var onDelete: () -> Void
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.3), radius: 5, y: 2)
            VStack(alignment: .leading){
                HStack{
                    if isListed != nil{
                        if !(isListed ?? false){
                            HStack{
                                Image(systemName: "xmark.rectangle")
                                Text("Item is unlisted")
                            }.opacity(0.5)
                        }else{
                            HStack{
                                Image(systemName: "checkmark.rectangle")
                                Text("Item is listed")
                            }.foregroundColor(.darkGreen)
                        }
                    }else{
                        HStack{
                            Image(systemName: "takeoutbag.and.cup.and.straw")
                            Text("Menu Item")
                        }.opacity(0.5)
                    }
                    Spacer()
                    Menu{
                        if isListed != nil{
                            Button(action: {
                                (onList ?? {})()
                            }) {
                                Label(isListed ?? true ? "Unlist Item" : "List Item", systemImage: isListed ?? true ? "xmark.rectangle" : "checkmark.rectangle")
                            }
                        }
                        
                        Button(action: {
                            onEdit()
                        }) {
                            Label("Edit", systemImage: "pencil")
                        }
                        
                        Button(action: {
                            onDelete()
                        }) {
                            Label("Delete", systemImage: "trash")
                            
                        }
                        
                        
                    } label: {
                        Button(action: {
                        }) {
                            Image(systemName: "ellipsis")
                                .bold()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.green)
                                .padding(0)
                            
                        }
                        .frame(width: 40, height: 40)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(50)
                        .padding(.top, 5)
                        
                    }
                    
                }
                HStack {
                    if imageUrl != nil{
                        WebImage(url: URL(string: imageUrl ?? ""))
                            .resizable()
                            .placeholder(Image("FoodIcon"))
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
                    }else{
                        Image(uiImage: uiImage ?? UIImage(imageLiteralResourceName: "FoodIcon"))
                            .resizable()
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("\(itemName)")
                            .padding(.horizontal)
                            .bold()
                        
                        Text("(\(weight) grams)")
                            .padding(.horizontal)
                    }
                    Spacer()
                    
                }
                
                Text("Old price: \(currencyString)\(formatNumber(Double(oldPrice)) ?? "0")")
                    .foregroundColor(.gray)
                
                Text("New price: \(currencyString)\(formatNumber(Double(newPrice)) ?? "0")")
                
                
                Text(description).foregroundColor(.gray)
                    .padding(.top)
                
                
            }.padding(.horizontal, 30)
                .padding(.vertical)
            
        }
        .padding(.vertical, 2)
        .padding(.horizontal, 10)
    }
}

#Preview {
    ItemRowView(imageUrl: "", itemName: "Apple Juice", oldPrice: 10000, newPrice: 5000, quantity: 2, weight: 100, description: "One of the most delicious apple juices in the world.", isListed: true, onList: {}, onEdit: { print("Button pressed") }, onDelete: {})
}
