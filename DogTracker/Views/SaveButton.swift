//
//  SaveButton.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/24/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct SaveButton: View  {
    
    var action: ()
    
    var body: some View {
        Button {
            action
        } label: {
            Text("Save")
                .padding()
        }
    }
}

//struct SaveButton_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
////            SaveButton()
////            MeasurementRow()
//        }.previewLayout(.sizeThatFits)
//    }
//}




