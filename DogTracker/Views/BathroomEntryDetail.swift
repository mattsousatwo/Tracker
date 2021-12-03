//
//  BathroomEntryDetail.swift
//  BathroomEntryDetail
//
//  Created by Matthew Sousa on 9/22/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

@available(iOS 15.0, *)
struct BathroomEntryDetail: View {

    @Environment(\.isPresented) var isPresented
    let dogs = Dogs()
    
    
    var entry: HistoryListElement
    
    @State private var viewState: BathroomEntryDetailState = .loading
    
    @State private var assignedDog: Dog? = nil
    @State private var didGiveTreat: Bool = false
    @State private var didUseBathroomInCorrectSpot: Bool = false
    @State private var entryNotes: String = ""
    @State private var entryDate: Date = Date()
    
    @State private var displayExtraDetails: Bool = false
    
    var body: some View {
        
        List {
            
            // date
            
            // dog
            
            extrasList()
            notesView()
            
        }
        .onAppear {
            onAppear()
        }
        
        
    }
}

// Methods
@available(iOS 15.0, *)
extension BathroomEntryDetail {
    /// Update View properties with HistoryElement values
    func onAppear() {
        
        /// Fetch descrete mode value
        
        if let bathroomEntry = entry.bathroomEntry {
            // Set inital Values for view
            unwrapDog()
            self.didGiveTreat = bathroomEntry.treat
            self.didUseBathroomInCorrectSpot = bathroomEntry.correctSpot
            self.entryNotes = bathroomEntry.notes ?? ""
            unwrapDate(string: bathroomEntry.date)
        }
    }

    /// Set saved date value to date property
    func unwrapDate(string: String?) {
        guard let dateString = string else { return }
        let formatter = DateControllerProvider()
        guard let newDate = formatter.convertStringToDate(dateString) else { return }
        entryDate = newDate
    }
    
    func unwrapDog() {
        guard let dogID = entry.bathroomEntry?.dogUUID else { return }
        assignedDog = dogs.fetchDog(id: dogID)
    }
    
}

// Views
@available(iOS 15.0, *)
extension BathroomEntryDetail {
    
    /// Toggle extras list
    func toggleExtrasButton() -> some View {
        return DisplayListToggleRow(title: "Extras",
                                    displayList: $displayExtraDetails)
            .foregroundColor(.primary)
            .padding()
    }

    // Extras
    func extrasList() -> some View {
        Section(header: Text("Secondary") ) {
            toggleExtrasButton()
            if displayExtraDetails == true {
                ToggleRow(icon: "pills",
                          title: "Treat",
                          isOn: $didGiveTreat)
                    .padding()
                
                ToggleRow(icon: "target",
                          title: "Correct Spot",
                          isOn: $didUseBathroomInCorrectSpot)
                    .padding()
            }
            
        }
    }
    
    // View to display saved notes
    func notesView() -> some View {
        // Text View for notes
        TextView(text: $entryNotes)
            .frame(height: 250,
                   alignment: .center)
            .padding(.horizontal, 5)
    }
    
    
}


enum BathroomEntryDetailState {
    case loading
    case successfulLoad
    case saving
    case deleting
    case failure
    
}


//
//struct BathroomEntryDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        BathroomEntryDetail(entry: BathroomEntry())
//    }
//}
