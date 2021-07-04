//
//  WeatherView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 7/4/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct WeatherView: View {
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: UIScreen.main.bounds.width - 40,
                   height: 175,
                   alignment: .center)
            .foregroundColor(.darkBlue)
            .overlay(
                VStack {
                    HStack {
                        
                        VStack {
                            Text("Watertown")
                                .foregroundColor(.white)
                            
                            Text("70º")
                                .foregroundColor(.white)
                                .font(.title)
                                .padding(.top, 5)
                        
                                
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Image(systemName: "cloud.fill")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 20,
                                        height: 20,
                                        alignment: .center)
                                .padding(.top)
                                .padding(.trailing)
                            Text("Cloudy")
                                .foregroundColor(.white)
                            Text("H: 77º L:64º")
                                .foregroundColor(.white)
                            
                        } .padding(.horizontal)
                    
                    }
                    .frame(width: UIScreen.main.bounds.width - 50,
                           height: (175 / 2) - 20,
                           alignment: .center)
                    .padding(.top)
                        
                    
                    ScrollView(.horizontal) {
                        HStack {
                            WeatherViewSegment()
                            WeatherViewSegment()
                            WeatherViewSegment()
                            WeatherViewSegment()
                            WeatherViewSegment()
                            WeatherViewSegment()
                            WeatherViewSegment()
                            WeatherViewSegment()
                        }
                    }
                    .padding(.bottom, 10)
                    
                }
                , alignment: .leading)
        
        
        
        
    }
    
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView().previewLayout(.sizeThatFits)
        WeatherViewSegment().previewLayout(.sizeThatFits)
    }
}


struct WeatherViewSegment: View {
    let width = (UIScreen.main.bounds.width - 40) / 5
    
    var body: some View {
        
        
        RoundedRectangle(cornerRadius: 10)
            .frame(width: width,
                   height: 80,
                   alignment: .center)
            .foregroundColor(.clear)
            .overlay(
                VStack {
                    Text("12PM")
                        .foregroundColor(.white)
                        
                    Image(systemName: "cloud.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: width / 3,
                               height: 15,
                               alignment: .center)
                        
                        .padding(5)
                    Text("65º")
                        .foregroundColor(.white)
                        
                }
                , alignment: .center)
        
        
    }
    
}
