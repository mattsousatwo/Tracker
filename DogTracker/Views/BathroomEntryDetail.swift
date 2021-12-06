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

    @Environment(\.dismiss) var isPresented
    private let dogs = Dogs()
    private let userDefaults = UserDefaults()
    
    /// Detail Properties
    let entry: HistoryListElement
    @Binding var didDismiss: Bool
    
    // View
    @State private var viewState: BathroomEntryDetailState = .loading
    
    // Entry Properties
    @State private var assignedDog: Dog? = nil
    @State private var didGiveTreat: Bool = false
    @State private var didUseBathroomInCorrectSpot: Bool = false
    @State private var entryNotes: String = ""
    @State private var entryDate: Date = Date()
    
    // Extra properties
    @State private var displayExtraDetails: Bool = false
    @State private var displaySelectDogSheet: Bool = false
    
    // Entry TypePicker
    @State private var entryMode: EntryMode = .bathroomMode
    @State private var type: Int = 0
    
    var body: some View {
        
        bathroomEntryDetailBody()
        .onAppear {
            onAppear()
        }
        .navigationTitle(Text("Entry Detail"))
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                saveButton()
            }
        }
        .navigationBarBackButtonHidden(true)
        
        
        
        
    }
}

// Methods
@available(iOS 15.0, *)
extension BathroomEntryDetail {
    /// Update View properties with HistoryElement values
    func onAppear() {
        
        if let bathroomEntry = entry.bathroomEntry {
            // Set inital Values for view
            self.assignedDog = dogs.fetchDog(id: bathroomEntry.dogUUID)
            self.didGiveTreat = bathroomEntry.treat
            self.didUseBathroomInCorrectSpot = bathroomEntry.correctSpot
            self.entryNotes = bathroomEntry.notes ?? ""
            unwrapDate(string: bathroomEntry.date)
            self.type = Int(bathroomEntry.type)
            self.displayExtraDetails = userDefaults.displayExtras()
        }
    }

    /// Set saved date value to date property
    func unwrapDate(string: String?) {
        guard let dateString = string else { return }
        let formatter = DateControllerProvider()
        guard let newDate = formatter.convertStringToDate(dateString) else { return }
        entryDate = newDate
    }
    
    func dismiss() {
        self.isPresented.callAsFunction()
        didDismiss = true
    }
    
}

// Views
@available(iOS 15.0, *)
extension BathroomEntryDetail {
    
    /// Body of the bathroom entry detail view
    func bathroomEntryDetailBody() -> some View {
        List {
            Section {
                typePicker()
                datePicker()
            }
            selectDogRow()
            extrasList()
        }
    }
    
    
    func backButton() -> some View {
        Button {
            dismiss()
        } label: {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back")
            }
        }
    }

    func saveButton() -> some View {
        Button {
            let bathroomBreak = BathroomBreak()
            guard let bathroomEntry = entry.bathroomEntry else { return }
            guard let assignedDog = assignedDog else { return }
            bathroomBreak.update(entry: bathroomEntry,
                                 correctSpot: didUseBathroomInCorrectSpot,
                                 notes: entryNotes,
                                 date: entryDate,
                                 dogUUID: assignedDog.uuid,
                                 treat: didGiveTreat,
                                 type: Int16(type) )
        } label: {
            Text("Save")
                .padding()
        }
    }
    
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
            notesView()
        }
        
        
    }
    
    // View to display saved notes
    func notesView() -> some View {
        // Text View for notes
        TextEditor(text: $entryNotes)
            .frame(height: 250,
                   alignment: .center)
            .padding(.horizontal, 5)
        
        
        
//        TextView(text: $entryNotes)
//            .frame(height: 250,
//                   alignment: .center)
//            .padding(.horizontal, 5)
    }
    
    /// View to display the selected dog for entry
    func selectDogRow() -> some View {
        SelectDogRow(dog: $assignedDog,
                     displaySheet: $displaySelectDogSheet)
    }
    
    /// View to display the saved date
    func datePicker() -> some View {
        DateEntryRow(date: $entryDate)
    }
    
    func typePicker() -> some View {
        
        EntryTypePicker(entryMode: $entryMode,
                        type: $type)
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
