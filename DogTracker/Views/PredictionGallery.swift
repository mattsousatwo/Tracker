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
    @State private var intervalTime: (hours: Int, minutes: Int) = (hours: 0, minutes: 0)
    @State private var expectedBathroomTime: String = "12:30PM"
    
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
            .font(.system(.body, design: .rounded))
            .padding()
            
    }
    
    // The Timer that counts down until the bathroom event should be expected
    func countdownTimer() -> some View {
        Text("\(intervalTime.hours):\(intervalTime.minutes)")
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


// Model

extension PredictionGallery {
    
    func onAppear() {
//        DispatchQueue.global(qos: .userInteractive).async {
            intervalTime = trackerConversion.getFrequencyOfBathroomUse()
            convertCountdownMinutesToTime()
//        }
        
        bathroomPhrase = bathroomPhrase.randomizePhrase()
    }
    
    func convertCountdownMinutesToTime() {
        let date = Date()
        let cal = Calendar.current
        guard let dateWithUpdatedHour = cal.date(byAdding: .hour,
                                                 value: intervalTime.hours,
                                                 to: date),
              let finalDate = cal.date(byAdding: .minute,
                                       value: intervalTime.minutes,
                                       to: dateWithUpdatedHour) else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let formattedDate = formatter.string(from: finalDate)
        expectedBathroomTime = formattedDate
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
    case facilities = "facilities"
    
    func randomizePhrase() -> BathroomPhrase {
        let randomIndex = Int.random(in: 0..<BathroomPhrase.allCases.count)
        return BathroomPhrase.allCases[randomIndex]
    }
}




