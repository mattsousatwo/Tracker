//
//  PredictionGallery.swift
//  DogTracker
//
//  Created by Matthew Sousa on 1/17/22.
//  Copyright © 2022 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct PredictionGallery: View {
    
    private let trackerConversion = TrackerConversion()
    @State private var bathroomPhrase : BathroomPhrase = .lavatory
    
    var body: some View {
        
        galleryBody()
            .overlay(titleText(), alignment: .topLeading)
            .overlay(countdownTimer(), alignment: .trailing)
            .overlay(countdownFinalTime(), alignment: .bottomTrailing)
            .onAppear {
                onAppear()
            }
    }
    
}

// Views
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
        Text("Your dog will need to use the \(bathroomPhrase.rawValue) in: ")
            .padding()
    }
    
    // The Timer that counts down until the bathroom event should be expected
    func countdownTimer() -> some View {
        Text("0:12")
            .font(.largeTitle)
            .bold()
            .padding(.trailing)
    }
    
    // The time the countdown is leading up until
    func countdownFinalTime() -> some View {
        Text("11:34 AM")
            .padding()
    }
    
    
}


// Model
extension PredictionGallery {
    
    func onAppear() {
        DispatchQueue.global(qos: .userInteractive).async {
            trackerConversion.getFrequencyOfBathroomUse()
        }
        
        bathroomPhrase = bathroomPhrase.randomizePhrase()
    }
}

struct PredictionGallery_Previews: PreviewProvider {
    static var previews: some View {
        PredictionGallery()
            .previewLayout(.sizeThatFits)
    }
}


enum BathroomPhrase: String, CaseIterable {
    case lavatory = "lavatory"
    case powderRoom = "powder room"
    case restroom = "restroom"
    case washroom = "washroom"
    
    func randomizePhrase() -> BathroomPhrase {
        let randomIndex = Int.random(in: 0..<BathroomPhrase.allCases.count)
        return BathroomPhrase.allCases[randomIndex]
    }
}
