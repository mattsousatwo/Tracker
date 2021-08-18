//
//  NewPrescriptionView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/17/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct NewPrescriptionView: View {
    
    @State private var prescriptionName: String = ""
    @State private var prescriptionAmount: String = ""
    @State private var prescriptionNotes: String = ""
    @State private var prescriptionAlarms: String = ""
    
    @State private var date: Date = Date()
    var body: some View {
        
        Form {
            TextField("Name", text: $prescriptionName)
                .padding()
            
            TextField("Amount", text: $prescriptionAmount)
                .padding()
            
            
            Section {
                NavigationLink(destination: NewAlarm(),
                               label: {
                                Text("Set up Alarm")
                                    .padding()
                               })
            }
            
            
            
            
        }
        .navigationBarTitle(Text("New Prescription") )
        .navigationBarItems(trailing: SaveButton(action: saveAction() ))
        
        
        
    }
}


extension NewPrescriptionView {
    
    func saveAction()  {

    }
    
}

struct NewPrescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        NewPrescriptionView()
    }
}
