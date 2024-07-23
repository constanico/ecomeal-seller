//
//  ReviewsView.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 24/11/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ReviewsView: View {
    
    var business: Business
    @ObservedObject var reviewViewModel = BusinessReviewViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(ColorString.lightGreen.colorText)
                    .ignoresSafeArea()
                VStack{
                    
                    if !reviewViewModel.reviews.isEmpty{
                        ScrollView{
                            VStack{
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                        .shadow(color: .black.opacity(0.1), radius: 5, y: 5)
                                        .padding(.horizontal, 10)
                                    
                                    HStack{
                                        WebImage(url: URL(string: business.imageUrl ?? ""))
                                            .resizable()
                                            .placeholder(Image(systemName: "photo"))
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(8)
                                            .padding(.trailing, 8)
                                        
                                        VStack{
                                            Text(business.businessName)
                                            
                                        }
                                        Spacer()
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                        
                                        Text("\(String(format: "%.1f", business.businessRating))")
                                            .font(.title2)
                                            .bold()
                                        
                                    }.padding()
                                        .padding(.horizontal, 10)
                                    
                                }
                                HStack{
                                    Text("Reviews (\(reviewViewModel.reviews.count))")
                                        .font(.title3)
                                        .bold()
                                    Spacer()
                                        .padding(.horizontal)
                                        .padding(.top)
                                }.padding()
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                        .shadow(color: .black.opacity(0.1), radius: 5, y: 5)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 2)
                                    VStack{
                                        ForEach(reviewViewModel.reviews.indices, id: \.self){ index in
                                            let item = reviewViewModel.reviews[index]
                                            HStack{
                                                VStack(alignment: .leading) {
                                                    HStack{
                                                        Image(systemName: "person.circle.fill")
                                                            .resizable()
                                                            .frame(width: 35, height: 35)
                                                            .opacity(0.3)
                                                            .padding(.trailing, 8)
                                                        
                                                        VStack(alignment: .leading){
                                                            Text(item.reviewerName).bold()
                                                                .font(.headline)
                                                            
                                                            HStack{
                                                                Image(systemName: "star.fill")
                                                                    .foregroundColor(.yellow)
                                                                    .padding(.trailing, -3)
                                                                
                                                                Text("\(String(format: "%.0f", item.reviewStarRating))")
                                                                Spacer()
                                                            }
                                                        }
                                                        
                                                    }
                                                    
                                                    Text(item.reviewContent)
                                                        .opacity(0.5)
                                                        .padding(.top, 10)
                                                    if index < reviewViewModel.reviews.count - 1{
                                                        Divider().padding(.vertical)
                                                    }
                                                    
                                                }
                                                Spacer()
                                            }
                                            
                                        }
                                        
                                    }.padding(.vertical, 20)
                                        .padding(.horizontal, 30)
                                }
                            }.padding(.vertical)
                            
                        }
                        .navigationTitle("Reviews")
                        .navigationBarTitleDisplayMode(.inline)

                        
                    }
                    else{
                        VStack{
                            Image(systemName: "star.bubble")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                            
                            Text("No reviews for this business yet")
                                .bold()
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                }
                .navigationBarItems(trailing:
                                        Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
                                    
                                    
                ).onAppear{
                    reviewViewModel.fetchReviews(forBusiness: business.id ?? "1")
                    print(reviewViewModel.reviews)
                    print(business.businessId)
                }
            }
            
        }
    }
}

#Preview {
    ReviewsView(business: businessDummy)
}
