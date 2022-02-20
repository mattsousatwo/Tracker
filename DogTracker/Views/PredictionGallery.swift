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
    
    @Binding var selectedDog: Dog
    
    private let predictionGalleryModel = PredictionGalleryModel()
    
    @State private var viewState = PredictionGalleryState.initalizing
    
    @State private var expectedBathroomTime: String = "--:-- --"
    
    @State private var currentTime = Date()
    
    let timer = Timer.publish(every: 1,
                              on: .main,
                              in: .common).autoconnect()
    
    var body: some View {

        predictionGallery()
            .onAppear {
                updateViewState()
            }
            .onChange(of: selectedDog, perform: { newValue in
                print("t5 - selectedDog: \(selectedDog.name ?? "no name"), NewValue: \(newValue) - \(viewState)")
                
                
                updateViewState()
                if let newTime = viewState.predictionTime() {
                
                    expectedBathroomTime = newTime.estimatedTime
                }
            })
            .onChange(of: viewState) { newState in
                print("t6 - galleryState has been updated \(viewState)")
                
                
                if let newTime = newState.predictionTime() {
                    expectedBathroomTime = newTime.estimatedTime
                }
            }
            .onReceive(timer) { newTime in
                
                
                let checkTimeHasPassed = predictionGalleryModel.checkIfOneMinuteHasPassed(currentTime)
                if checkTimeHasPassed.hasPassed == true {
                    if let updatedTime = checkTimeHasPassed.time {
                        currentTime = updatedTime
                    }
                    if let updatedState = predictionGalleryModel.decrementCountdown(viewState) {
                        viewState = updatedState
                        
                        
                        if let newState = updatedState.predictionTime() {
                            print("t4 - expectedBathroomTime - \(expectedBathroomTime)")
                            expectedBathroomTime = newState.estimatedTime
                        }
                                                
                        print("t4 - updateTime")
                    }
                }
                
                
                print("t4 - time: \(newTime)")
            }

        
    }
    
}

// Views
@available(iOS 14.0, *)
extension PredictionGallery {
    
    
    func predictionGallery() -> some View {
        galleryBody()
            .overlay(titleText(), alignment: .topLeading)
            .overlay(countdownTimer(), alignment: .trailing)
            .overlay(countdownFinalTime(), alignment: .bottomTrailing)
    }
    
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
extension PredictionGallery {
    
    func updateViewState() {
        viewState = .calculating
        if selectedDog.name != nil  {  // SelectedDogs properties are being accessed before it is initalized - set up states for statistic view 
            DispatchQueue.global(qos: .userInteractive).async {
                viewState = predictionGalleryModel.calculatePredictionRate(of: selectedDog)
            }
        }
    }
    
    
        
}

//
//@available(iOS 14.0, *)
//struct PredictionGallery_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            PredictionGallery()
//        }.previewLayout(.sizeThatFits)
//    }
//}





