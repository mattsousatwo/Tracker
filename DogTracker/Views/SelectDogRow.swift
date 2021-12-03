//
//  SelectDogRow.swift
//  DogTracker
//
//  Created by Matthew Sousa on 12/3/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

/// List Row with a dogs name used to trigger a sheet to select which dog the user would like to be displayed
@available(iOS 14.0, *)
struct SelectDogRow: View {
    
    let dogs = Dogs()
    
    @Binding var dogID: String
    @Binding var displaySheet: Bool
    
    @State private var name: String = ""
    @State private var assignedDog: Dog?
    @State private var selectDogRowState: SelectDogRowState
    
    
    init(dogID: Binding<String>, displaySheet: Binding<Bool>) {
        self._dogID = dogID
        self._displaySheet = displaySheet
        self.selectDogRowState = .fetchingDog
    }
    
    
    var body: some View {
        
        
        HStack {
            
            switch selectDogRowState {
            case .fetchingDog:
                fetchingDogBody()
            case .loadingView:
                loadingViewBody()
            case .success:
                successfulLoadBody()
            case .failure:
                failureBody()
            }
            
            
            
            Spacer()
            Image(systemName: "chevron.right")
        }
        .onAppear {
            fetchDog()
        }
        .onChange(of: selectDogRowState) { newState in
            if newState == .loadingView {
                loadViewBody()
            }
        }
        .onChange(of: assignedDog) { newDog in
            guard let newDogName = newDog?.name else { return }
            name = newDogName
            guard let newDogID = newDog?.uuid else { return }
            dogID = newDogID
        }
        
        
    }
    
    
    func fetchingDogBody() -> some View {
        Text("")
    }
    
    /// Body for view while loading dog name
    func loadingViewBody() -> some View {
        Text("")
    }
    
    /// Body for view after dogs name has been fetched
    func successfulLoadBody() -> some View {
        
            Button {
                self.displaySheet.toggle()
            } label: {
                Text(name)
                    .padding()
                    .foregroundColor(.lightBlue)
            }
            
            .sheet(isPresented: $displaySheet) {
                SelectDogList(favoriteDog: $assignedDog,
                              isPresented: $displaySheet,
                              favoriteEditorIsOn: false)
            }
        

    }
        
    func failureBody() -> some View {
        Text("Failure to load Dog")
    }
    
    
    
    func loadViewBody() {
        if selectDogRowState == .loadingView {
            guard let assignedDog = assignedDog else { return failure() }
            guard let dogName = assignedDog.name else { return failure() }
            name = dogName
            success()
        }
    }
    
    func fetchDog() {
        assignedDog = dogs.fetchDog(id: dogID)
        selectDogRowState = .loadingView
    }
    
    func failure() {
        selectDogRowState = .failure
    }
    
    func success() {
        selectDogRowState = .success
    }
    
}

enum SelectDogRowState {
    case fetchingDog
    case loadingView
    case success
    case failure
}

//struct SelectDogRow_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectDogRow()
//    }
//}
