//
//  ProfileView.swift
//  DogTracker
//
//  Created by Matthew Sousa on 8/27/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import UIKit
import SwiftUI

struct ProfileView: View {
    
    @ObservedObject private var dogs = Dogs()
    @ObservedObject var bathroomBreak = BathroomBreak()
    @ObservedObject var foodEntries = FoodEntries()
    let conversion = Conversion()
    
    var selectedDog: Dog
    
    @State private var changeImage = false
    @State private var editName = false
    @State private var editEmail = false
    @State private var editPass = false
    @State private var deleteAccount = false
    
    
    /// History Date
    @State private var firstDate: Date = Date()
    @State private var lastDate: Date = Date()
    @State private var currentWeek: String = "Current Week"
    @State private var graphWeek = Date().asFormattedString()
    
    
    // Dog Properties
    @State private var dogName: String = ""
    @State private var dogWeight: String = "0.0"
    @State private var breeds: String = ""
    @State private var birthdate: String = ""
    //    @State private var isFavorite: Bool = false
    @State private var dogImage = UIImage()
    
    @State private var dogBirthdate: Date = Date()
    
    
    // Breeds
    @State private var displayToggle = false
    @State private var presentSelectBreedList = false
    @State private var selectedDogBreed: [String] = []
    @State private var editingMode = false
    
    
    /// BathroomMode: True, FoodMode: False
    @State var bathroomOrFoodMode: Bool = true
    /// History recordings
    @State private var historyElements: [HistoryElement] = []
    
    /// Save the selected image to dog
    func saveImage() {
        
            selectedDog.update(image: dogImage)
        
    }
    
    func deleteButton() -> some View {
        return
            Section {
                
                // Save button - TESTING - go to SwiftUIView
                Button("Delete Account") {
                    self.deleteAccount.toggle()
                }.sheet(isPresented: $deleteAccount) {
                    HistoryView()
                }
                
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(Color.red)
                .foregroundColor(Color.white)
                .font(.headline)
                .cornerRadius(15)
                .shadow(radius: 2)
                
                
            }
    }
    
    var body: some View {
        
        
        if #available(iOS 14.0, *) {
            Form {
                
                Section(header: Text("Edit Profile")) {
                    
                    Group {
                        
                        nameTexfield()
                        
                        editWeightfield()
                        
                        editBirthdateRow()
                        
                        
                                                
                    } // Group
                    
                } // Section
                
                breedEntryView()

                
                historySection()
                
                deleteButton()
            } // Form
            .navigationTitle(Text(dogName))
            .navigationBarItems(trailing: profileImage())
            
            .onAppear {

                
                
                
                    if let name = selectedDog.name {
                        dogName = name
                    }
                    
                    
                
                
                
                
                onAppearLoadElements()
                
                guard let image = selectedDog.convertImage() else { return }
                self.dogImage = image
            }
            
            .onChange(of: selectedDog, perform: { value in
                onAppearLoadElements()
            })
            .onChange(of: dogImage, perform: { value in
                saveImage()
            })
        }
        
    } // Body
    
    
} // ProfileView

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}

// TextRows
extension ProfileView {
    
    func profileImage() -> some View {
        return
            Button(action: {
                self.changeImage.toggle()
            }) {
                Image(uiImage: self.dogImage).resizable().clipShape(Circle())
                    .frame(width: 35, height: 35)
                    .padding()
            } .sheet(isPresented: $changeImage) {
                ImagePicker(selectedImage: self.$dogImage, sourceType: .photoLibrary)
            }
        
    }
    
    /// Edit name check field
    func nameTexfield() -> some View {
        return
            // Edit Name
            HStack {
                // Icon
                Icon(image: "person",
                     color: .green,
                     frame: 40)
                
                TextField("Name:", text: $dogName)
                    .padding()
                
            }
        
    }
    
    /// Edit weight field
    func editWeightfield() -> some View {
        return
            HStack {
                Icon(image: "scalemass",
                     color: .lightOrange,
                     frame: 40)
                
                TextField("Weight:", text: $dogWeight)
                    .padding()
            }
        
        
    }
    
    func editBirthdateRow() -> some View {
        return
            HStack {
                Icon(image: "giftcard",
                     color: .lightGreen,
                     frame: 40)
                
                DatePicker("Date",
                           selection: $dogBirthdate,
                           displayedComponents: .date)
                            .labelsHidden()
                            .padding()
            }
    }
    
    
    func breedEntryView() -> some View {
        return
            
                Section(header:
                            
                            HStack {
                                if #available(iOS 14.0, *) {
                                    Text("Breed")
                                        .textCase(.none)
                                }
                                Spacer()
                                Button {
                                    self.presentSelectBreedList.toggle()
                                } label: {
                                    if #available(iOS 14.0, *) {
                                        Text("Add")
                                            .textCase(.none)
                                            .padding(.trailing)
                                    }
                                }.sheet(isPresented: $presentSelectBreedList) {
                                    SelectDogBreedList(isPresented: $presentSelectBreedList,
                                                       selectedBreed: $selectedDogBreed)
                                }
                                //                                .onChange(of: selectedDogBreed, perform: { _ in
                                //                                    updateNewDogState()
                                //                                })
                                
                                
                                
                                
                            }
                ) {
                    
                    
                    Button {
                        withAnimation {
                            self.displayToggle.toggle()
                        }
                    } label: {
                        HStack {
                            
                            breedsTitle()
                                .animation(.none)
                            
                            Spacer()
                            
                            if editingMode == false {
                                
                                menuIndicator()
                                    
                                    .rotationEffect(.degrees(displayToggle ? 90 : 0), anchor: .center)
                                    .animation(displayToggle ? .easeIn : nil)
                                
                            } else if editingMode == true {
                                
                                doneButton()
                            }
                        }
                        
                    }
                    
                    .padding()
                    
                    if displayToggle == true {
                        
                        ForEach(0..<selectedDogBreed.count, id: \.self) { i in
                            HStack {
                                if editingMode == true {
                                    
                                    minusButton(removeAtIndex: i)
                                }
                                Text(selectedDogBreed[i])
                                    .padding(10)
                                Spacer()
                                
                            }
                            .padding()
                            .onLongPressGesture {
                                self.editingMode = true
                            }
                            
                            
                        }
                    }
                
            }
    }
    
    func breedsTitle() -> some View {
        return HStack {
            Text("Breeds").font(.subheadline)
                .foregroundColor(.primary)
                .padding(.leading, 10)
                .padding(.vertical, 10)
            
            Text("(\(selectedDogBreed.count))").font(.subheadline)
                .foregroundColor(.gray)
        }
    }
    
    func menuIndicator() -> some View {
        return
            Image(systemName: "chevron.right")
            .frame(width: 20, height: 20)
            .padding(5)
    }
    
    func doneButton() -> some View {
        return
            Button {
                self.editingMode = false
            } label: {
                Text("Done")
                    .bold()
                    .foregroundColor(.blue)
            }
    }
    
    func minusButton(removeAtIndex i: Int) -> some View {
        return Image(systemName: "minus")
            .frame(width: 20, height: 20)
            .padding(5)
            .foregroundColor(editingMode ? .white : .clear)
            .background(editingMode ? Color.red : .clear)
            .opacity(editingMode ? 1.0 : 0.0)
            .mask(Circle())
            .animation(editingMode ? .default : nil)
            .transition(AnyTransition.opacity.combined(with: .move(edge: .leading)))
            .onTapGesture {
                withAnimation(.default) {
                    if editingMode == true {
                        // delete row
                        selectedDogBreed.remove(at: i)
                    }
                }
            }
            .animation(.default, value: selectedDogBreed)
    }
    
    
}


extension ProfileView {
    
    func section(_ entry: HistoryElement) -> some View {
        return
            VStack(alignment: .leading) {
                if entry.entries.count != 0 {
                    Text(entry.name)
                        .fontWeight(.bold)
                        .padding(.vertical)
                    Divider()
                    ForEach(0..<entry.entries.count, id: \.self) { i in
                        if let date = conversion.historyRowFormat(entry.entries[i].date) {
                            VStack(alignment: .leading) {
                                Text(date)
                                    .padding(.vertical)
                                if i != entry.entries.count - 1 {
                                    Divider()
                                }
                            }
                        }
                        
                    }
                    //                    .onDelete { index in
                    //                        deleteBathroomEntry(at: index, entries: entry.entries)
                    //                    }
                    
                }
                
            }
        
    }
    
    func getAllBathroomEntriesByDog() -> [HistoryElement] {
        if bathroomBreak.bathroomEntries?.count == 0 {
            bathroomBreak.fetchAll()
        }
        
        var entries = [BathroomEntry]()
        var elements = [HistoryElement]()
        

            if let dogsEntries = bathroomBreak.fetchAllEntries(for: selectedDog.uuid) {
                entries = dogsEntries.sorted(by: { (entryOne, entryTwo) in
                    guard let dateOne = entryOne.date, let dateTwo = entryTwo.date else { return false }
                    return dateOne < dateTwo
                    
                })
            }
            
            if let name = selectedDog.name {
                elements.append(HistoryElement(name: name, entries: entries))
            }
            
        
        return elements
    }
    
    func deleteBathroomEntry(at offset: IndexSet, entries: [BathroomEntry]) {
        offset.forEach { (index) in
            
            if let bathroomID = entries[index].uid {
                bathroomBreak.deleteSpecificElement(.bathroomBreak, id: bathroomID)
            }
            onAppearLoadElements()
            
        }
    }
    
    func onAppearLoadElements() {
        historyElements = getAllBathroomEntriesByDog()
        if bathroomOrFoodMode == true {
            bathroomBreak.fetchAll()
        } else {
            foodEntries.fetchAll()
        }
        //        print("Bathroom Use count \(bathroomBreak.bathroomEntries?.count)")
    }
    
    func historySection() -> some View {
        return
            Section(header:
                        
                        VStack(alignment: .leading) {
                            
                            dateControl()
                     
                            HStack {
                                Text(bathroomOrFoodMode ? "Bathroom Use" : "Food Consumption")
                                Spacer()
                                if #available(iOS 14.0, *) {
                                    Toggle(isOn: $bathroomOrFoodMode) {
                                        Text("")
                                    }
                                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                                    .padding(.bottom, 5)
                                } else {
                                    // Fallback on earlier versions
                                }
                            }
                        }
                    
                    
                    
            ) {
                
                
                switch bathroomOrFoodMode {
                case true:
                    if let entries = bathroomBreak.bathroomEntries {
                        if entries.count != 0 {
                            ForEach(historyElements, id: \.self) { entry in
                                if entry.entries.count != 0 {
                                    section(entry)
                                }
                            }
                        } else {
                            Text("There are 0 bathroom entries")
                        }
                    }

                    
                case false:
                    if let entries = foodEntries.entries {
                        if entries.count >= 1 {
                            
                            ForEach(entries, id: \.self) { entry in
                                if let date = entry.date {
                                    
                                    if let date = conversion.convertDate(date), let convertedDate = conversion.formatDateToNormalStyle(date) {
                                        Text(convertedDate)
                                            .padding()
                                    }
                                }
                            }
                            //                            .onDelete(perform: deleteFoodEntry )
                            
                        } else {
                            Text("There are 0 food entries")
                        }
                        
                        
                        
                    }
                }
                
                
            }
        
    }
}


extension ProfileView {
    
    
    func dateControl() -> some View {
        return
            HStack {
                changeDateButton(.minus)
                    .padding(.leading, 8)
                Spacer()
                Button {
                    setToCurrentDate()
                    
                    
  
                    
                } label: {
                    Text(currentWeek).font(.system(size: 25,
                                                   weight: .light,
                                                   design: .rounded))
                        .foregroundColor(.primary)
                }.buttonStyle(PlainButtonStyle() )
                 Spacer()
                changeDateButton(.plus)
                    .padding(.trailing, 8)
            }
            .onAppear {
                getBeginingAndEndOfCurrentWeek()
            }
    }
    
    private func changeDateButton(_ direction: DateButtonType) -> some View {
        return
            Button {
                switch direction {
                case .minus:
                    print("minus one day")
                    subtractFromDate()
                case .plus:
                    print("advance one day")
                    addToDate()
                }
            } label: {
                direction.image
                    .resizable()
                    .frame(width: 35, height: 35, alignment: .center)
                    .foregroundColor(.gray)
            }.buttonStyle(PlainButtonStyle() )
    }

    
    private func addToDate() {
        // add one week from firstDate
        if let oneWeekAdded = firstDate.addOneWeek(),
           let lastWeekDay = oneWeekAdded.addOneWeek() {
            firstDate = oneWeekAdded
            let formatter = DateFormatter()
            updateCurrentWeek(formatter.graphDateFormat(firstDate),
                              formatter.graphDateFormat(lastWeekDay))
            print(firstDate)
        }
    }
    
    private func subtractFromDate() {
        // minus one week from firstDate
        if let oneLessWeek = firstDate.subtractOneWeek(),
           let plusOneWeek = oneLessWeek.addOneWeek() {
            firstDate = oneLessWeek
            let formatter = DateFormatter()
            updateCurrentWeek(formatter.graphDateFormat(firstDate),
                              formatter.graphDateFormat(plusOneWeek))
            print(firstDate)
        }
        
    }
    
    /// Change graph to current week
    private func setToCurrentDate() {
        let formatter = DateFormatter()
        let today = Date()
        guard let plusOneWeek = today.addOneWeek() else { return }
        firstDate = today
        updateCurrentWeek(formatter.graphDateFormat(today),
                          formatter.graphDateFormat(plusOneWeek))
        
    }

    enum DateButtonType {
        case minus
        case plus
        
        var image: Image {
            switch self {
            case .minus:
                return Image(systemName: "arrow.left.circle.fill")
            case .plus:
                return Image(systemName: "arrow.right.circle.fill")
            }
        }
    }
    
    func updateCurrentWeek(_ first: String, _ last: String) {
        currentWeek = "\(first) - \(last)"
    }
    
    func getDatesRange() -> [Date] {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        let today = calendar.startOfDay(for: firstDate )
        let dayOfTheWeek = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound )
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfTheWeek, to: today)}
        return days
    }
    
    func getFirstAndLastOfWeek() -> (first: String, last: String)? {
        
        let days = getDatesRange()
        
        let formatter = DateFormatter()
        
        guard let firstDay = days.first else { return nil }
        let firstDayString = formatter.graphDateFormat(firstDay)
        
        guard let lastDay = days.last else { return nil }
        let lastDayString = formatter.graphDateFormat(lastDay)
        
        return (first: firstDayString, last: lastDayString)
    }
    
    func getBeginingAndEndOfCurrentWeek() {
        
        
        let firstAndLastDates = getFirstAndLastOfWeek()
        
        if let graphWeekDates = firstAndLastDates {
            updateCurrentWeek(graphWeekDates.first, graphWeekDates.last)
        }
        
        
        let days = getDatesRange()
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        var formattedDatesContainer: [String] = []
        for day in days {
            formattedDatesContainer.append(formatter.string(from: day))
        }
        
    }
    
    
    
}
