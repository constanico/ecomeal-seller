//
//  QRCodeGeneratorView.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 27/11/23.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeGeneratorView: View {
    let dataString: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            Color(ColorString.lightGreen.colorText)
                .ignoresSafeArea()
            VStack{
                Spacer()
                Image(uiImage: generateQRCode(from: dataString))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .shadow(color: .black.opacity(0.2), radius: 5, y: 5)
                VStack{
                    Text("Show QR code to customer")
                        .font(.title2)
                        .bold()
                        .padding(.top)
                        .padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    Text("For the customer, navigate to Profile > Pay and point the camera to the QR code.")
                        .opacity(0.5)
                        .padding()
                        .padding(.bottom, 5)
                        .multilineTextAlignment(.center)
                }
                    .background(.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 2, y: 3)
                    .padding()
                
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Dismiss")
                        .foregroundColor(.white)
                        .bold()
                        .frame(width: 300, height: 55)
                        .background(.green)
                        .cornerRadius(50)
                }.padding(.bottom)
                
            }
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

#Preview {
    QRCodeGeneratorView(dataString: "ECOMEAL")
}
