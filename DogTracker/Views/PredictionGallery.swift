//
//  PredictionGallery.swift
//  DogTracker
//
//  Created by Matthew Sousa on 1/17/22.
//  Copyright © 2022 Matthew Sousa. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct PredictionGallery: View {
    
    
    private let predictionGalleryModel = PredictionGalleryModel()
    
    @State private var viewState = PredictionGalleryState.initalizing
    
    @State private var expectedBathroomTime: String = "--:-- --"
    
    let timer = Timer.publish(every: 1,
                              on: .main,
                              in: .common).autoconnect()
    
    var body: some View {
        
        galleryBody()
            .overlay(titleText(), alignment: .topLeading)
            .overlay(countdownTimer(), alignment: .trailing)
            .overlay(countdownFinalTime(), alignment: .bottomTrailing)
            .onAppear {
                
                DispatchQueue.global(qos: .userInteractive).async {
                    viewState = predictionGalleryModel.onAppear()
                    
                }
            }
            .onChange(of: viewState) { newState in
                switch newState {
                case .success(let time):
                    expectedBathroomTime = time.estimatedTime
                default:
                    break 
                    
                }
            }
            .onReceive(timer) { newTime in
                
                if let updatedState = predictionGalleryModel.decrementCountdown(viewState) {
                    viewState = updatedState
                }
                print("t4 - time: \(newTime)")
            }
    }
    
}

// Views
@available(iOS 14.0, *)
extension PredictionGallery {
    
    // Body of the galley
    func galleryBody() -> some View {
        RoundedRectangle(cornerRadius: 12)
            .frame(width: UIScreen.main.bounds.width - 20,
                   height: 200,
                   alignment: .center)
            .foregroundColor(.lightBlue)
    }
    
    // Main title text view
    func titleText() -> some View {
//        Text("Your dog will need to use the \(bathroomPhrase.rawValue) in: ")
        Text(predictionGalleryModel.titleString())
            .font(.system(.body, design: .rounded))
            .padding()
            
    }
    
    // The Timer that counts down until the bathroom event should be expected
    func countdownTimer() -> some View {
        Text(predictionGalleryModel.countdownTimerString(viewState ) )
            .font(.system(.largeTitle, design: .rounded))
            .bold()
            .padding(.trailing)
    }
    
    // The time the countdown is leading up until
    func countdownFinalTime() -> some View {
        HStack {
            Image(systemName: "bell")
                .resizable()
                .frame(width: 20, height: 20, alignment: .center)
            Text(expectedBathroomTime)
                .font(.headline)
                .padding(.vertical)
                .padding(.trailing)
        }
    }
    
    
}

@available(iOS 14.0, *)
struct PredictionGallery_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PredictionGallery()
        }.previewLayout(.sizeThatFits)
    }
}





