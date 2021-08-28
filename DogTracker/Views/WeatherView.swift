//
//  WeatherView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 7/4/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct WeatherView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("Weather:").font(.system(size: 25,
                                          weight: .medium,
                                          design: .rounded))
            
            RoundedRectangle(cornerRadius: 10)
                .frame(width: UIScreen.main.bounds.width - 20,
                       height: 220,
                       alignment: .center)
                .foregroundColor(colorScheme == .dark ? Color.darkBlue: .lightBlue)
                .overlay(
                    VStack {
                        HStack {
                            
                            VStack {
                                Text("Watertown")
                                    .foregroundColor(.white)
                                    .padding(.top, 10)
                                
                                Text("70º")
                                    .foregroundColor(.white)
                                    .font(.system(size: 50,
                                                  weight: .light,
                                                  design: .rounded))
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
                                
                                Text("Cloudy")
                                    .foregroundColor(.white)
                                Text("H: 77º L:64º")
                                    .foregroundColor(.white)
                                
                            } .padding(.trailing, 5)
                            
                        }
                        .frame(width: UIScreen.main.bounds.width - 50,
                               height: (175 / 2) - 20,
                               alignment: .center)
                        .padding(.top)
                        
                        Spacer()
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
                        .padding(.bottom, 12)
                        
                    }
                    , alignment: .leading)
            
        }
        
        
        
    }
    
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
        
        WeatherView()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.light)

//        WeatherViewSegment().previewLayout(.sizeThatFits)
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
