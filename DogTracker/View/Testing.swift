//
//  Testing.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/20/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct Testing: View {
    
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    
    
    var body: some View {
        VStack {
            
            Image(uiImage: self.image)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            Button(action: {
                self.isShowPhotoLibrary = true
            }) {
                HStack {
                    Image(systemName: "photo")
                        .font(.system(size: 20))
                    
                    Text("Photo Library")
                        .font(.headline)
                } // HStack
                
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding()
                
            } // Button config
            
            
            
        } // VStack
            .sheet(isPresented: $isShowPhotoLibrary) {
                ImagePicker(selectedImage: self.$image, sourceType: .photoLibrary)
        }
        

    } // Body
     
} // Testing

struct Testing_Previews: PreviewProvider {
    static var previews: some View {
        Testing()
    }
}
