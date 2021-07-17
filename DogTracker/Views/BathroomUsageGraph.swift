//
//  BathroomUsageGraph.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/5/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

/// Layered bar graph to show
struct BathroomUsageGraph: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var bathroomBreak = BathroomBreak()
    @ObservedObject var dogs = Dogs()
    @ObservedObject var foodEntries = FoodEntries()
    @ObservedObject var userDefaults = UserDefaults()
    
    @State var selectedDog: Dog?
    @State var selectedDogName: String = "Choose Dog"
    
    // size
    var width: CGFloat = UIScreen.main.bounds.width - 20
    var height: CGFloat = 300
    
    // Coloring
    @State private var backgroundColor: Color = .white
    var barColors: [Color] = [.lightBlue, .azure, .darkBlue]
    
    // Content
    //    var values: [CGFloat] = [100, 250, 110, 85, 50, 105, 130]
    var values: [CGFloat] = [0, 0, 3, 0, 0, 0, 0 ]
    var days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var valueIncrements: [String] = ["6", "5", "4", "3", "2", "1", ""]
    @State private var bathroomEntries: [BathroomEntry] = []
    
    // Configuration
    var barSpacing: CGFloat = 8 // HStack alignment spacing
    var horizontalPadding: CGFloat = 8 // Horizontal padding for each bar
    var textBoxWidth: CGFloat = 30 // width for textbox
    var textBoxHeight: CGFloat = 30 // width for textbox
    
    func updateBackgroundColor() {
        switch colorScheme {
        case .light:
            backgroundColor = .black
        case .dark:
            backgroundColor = .backgroundGray
        default:
            backgroundColor = .backgroundGray
        }
    }
    
    func updateBackgroundOnAppear() {
        switch colorScheme {
        case .dark:
            backgroundColor = .black
        case .light:
            backgroundColor = .backgroundGray
        default:
            backgroundColor = .backgroundGray
        }
    }
    
    @State private var popover: Bool = false
    
    @State private var currentWeek: String = "Current Week"
    
    @State private var graphElements: [GraphElement]?
    
    func getBeginingAndEndOfCurrentWeek() {
        if let favoriteDog = dogs.getFavoriteDog() {
            selectedDog = favoriteDog
        }
        
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        let today = calendar.startOfDay(for: Date() )
        let dayOfTheWeek = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound )
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfTheWeek, to: today)}
        
        let formatter = DateFormatter()
        
        guard let firstDay = days.first else { return }
        let firstDayString = formatter.graphDateFormat(firstDay)
        
        guard let lastDay = days.last else { return }
        let lastDayString = formatter.graphDateFormat(lastDay)
        
        currentWeek = "\(firstDayString) - \(lastDayString)"
        
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        var formattedDatesContainer: [String] = []
        for day in days {
            formattedDatesContainer.append(formatter.string(from: day))
        }
        
        //        if let selectedDog = selectedDog,
        //           let currentEntries = bathroomBreak.getEntriesForWeek(formattedDatesContainer,
        //                                                                for: selectedDog,
        //                                                                type: selectedEntryType) {
        //
        //            let elements = bathroomBreak.convertEntriesToGraphElements(currentEntries)
        //            graphElements = []
        //            graphElements = elements
        //            if let graphElements = graphElements {
        //                for element in graphElements {
        //                    print("\(element.day.asString()), \(element.bathroomEntries.count)")
        //                }
        //                print("\n")
        //            }
        //        }
        if let selectedDog = selectedDog {
            getGraphElements(for: selectedDog, in: formattedDatesContainer, of: selectedEntryType)
        }
    }
    
    // Will be used to replace ln: 101, bathroomBreak.getEntriesForWeek()
    /// Get bathroom or food entries depending on selected type to be converted to graphElements
    func getGraphElements(for dog: Dog, in week: [String], of type: EntryType ) {
        
        switch selectedEntryType {
        case .pee, .poop, .vomit:
            if let bathroomElements = bathroomBreak.getEntriesForWeek(week, for: dog, type: type) {
                let elements = bathroomBreak.convertEntriesToGraphElements(bathroomElements)
                graphElements?.removeAll()
                graphElements = elements
            }
        case .food, .water:
            if let foodElements = foodEntries.getEntries(in: week, for: dog, ofType: type) {
                let elements = foodEntries.convertFoodEntriesToGraphElements(foodElements)
                for element in elements {
                    print("\(element.day), \(element.foodEntries)")
                }
                graphElements = []
                graphElements = elements
                if let graphElements = graphElements {
                    print("\n GraphElements")
                    for element in graphElements {
                        print("\(element.day), \(element.foodEntries)")
                    }
                }
            }
        }
        
    }
    
    
    
    @State private var selectedDay: Int = 0
    func getCurrentWeekday() {
        let calendar = Calendar.current
        let today = Date()
        let dayComponent = calendar.component(.weekday, from: today)
        selectedDay = dayComponent
    }
    
    /// adjust entry count to reflect graph y coordinates
    func convertBarValue(_ value: Int) -> CGFloat {
        return CGFloat(((value - 1) * 45) + 20)
    }
    
    @State private var hideVomitGraph: Bool = false
    @State private var entryTypes: [EntryType] = [.pee, .poop, .vomit, .food, .water]
    @State private var selectedEntryType: EntryType = .pee
    func cycleThroughEntryTypes() {
        switch selectedEntryType {
        case .pee:
            selectedEntryType = .poop
        case .poop:
            if hideVomitGraph == true {
                selectedEntryType = .food
            } else {
                selectedEntryType = .vomit
            }
        case .vomit:
            selectedEntryType = .food
        case .food:
            selectedEntryType = .water
        case .water:
            selectedEntryType = .pee
        }
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                
                if #available(iOS 14.0, *) {
                    Button {
                        cycleThroughEntryTypes()
                    } label: {
                        Text("\(selectedEntryType.rawValue):").font(.system(size: 25,
                                                                            weight: .medium,
                                                                            design: .rounded))
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onAppear {
                        if let selectedDog = selectedDog,  let name = selectedDog.name {
                            selectedDogName = name
                        }
                    }
                    .onChange(of: selectedDog, perform: { value in
                        if let selectedDog = selectedDog,  let name = selectedDog.name {
                            selectedDogName = name
                        }
                    })
                }
                
                Spacer()
                
                Text(currentWeek).font(.system(size: 15,
                                               weight: .medium,
                                               design: .rounded))
                    .onAppear {
                        getCurrentWeekday()
                    }
                
            }
            // Background
            if #available(iOS 14.0, *) {
                backgroundColor
                    .onTapGesture {
                        cycleThroughEntryTypes()
                    }
                    .onAppear {
                        updateBackgroundOnAppear()
                    }
                    .onChange(of: colorScheme, perform: { value in
                        updateBackgroundColor()
                    })
                    
                    .frame(width: width,
                           height: height)
                    .cornerRadius(12)
                    .overlay(
                        HStack(alignment: .bottom) {
                            
                            VStack(alignment: .leading, spacing: 15) {
                                
                                ForEach(valueIncrements, id: \.self) { day in
                                    Text(day) // value.day
                                        .frame(width: self.textBoxWidth,
                                               height: self.textBoxHeight)
                                        .font(.system(size: 10))
                                        .opacity(0.7)
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                        .shadow(radius: 5)
                                    
                                } // forEach
                                .padding(.leading, horizontalPadding)
                            } // VStack
                            
                            //                            .padding(.leading)
                            if let graphElements = graphElements {
                                VStack(alignment: .center) {
                                    
                                    HStack(alignment: .bottom, spacing: barSpacing) {
                                        
                                        ForEach(graphElements, id: \.self) { value in
                                            // Use ForEach to set this up
                                            VStack {
                                                if value.bathroomEntries.count != 0 {
                                                    if value.bathroomEntries.count == 0 {
                                                        Bar(title: "",
                                                            height: 5,
                                                            barColor: .gray,
                                                            barWidth: self.width / 25,
                                                            textBoxWidth: self.textBoxWidth,
                                                            textBoxHeight: self.textBoxHeight)
                                                    } else {
                                                        Bar(title: "\(value.bathroomEntries.count)",
                                                            height: convertBarValue(value.bathroomEntries.count),
                                                            barColor: colorScheme == .dark ? .darkBlue : .lightBlue,
                                                            barWidth: self.width / 25,
                                                            textBoxWidth: self.textBoxWidth,
                                                            textBoxHeight: self.textBoxHeight)
                                                    }
                                                }
                                                else {
                                                        if value.foodEntries.count == 0 {
                                                            Bar(title: "",
                                                                height: 5,
                                                                barColor: .gray,
                                                                barWidth: self.width / 25,
                                                                textBoxWidth: self.textBoxWidth,
                                                                textBoxHeight: self.textBoxHeight)
                                                        } else {
                                                            Bar(title: "\(value.foodEntries.count)",
                                                                height: convertBarValue(value.foodEntries.count),
                                                                barColor: colorScheme == .dark ? .darkBlue : .lightBlue,
                                                                barWidth: self.width / 25,
                                                                textBoxWidth: self.textBoxWidth,
                                                                textBoxHeight: self.textBoxHeight)
                                                        }
//
                                                    
                                                }
                                            } // VStack
                                        } // ForEach
                                        .padding(.horizontal, horizontalPadding)
                                        .animation(.easeInOut)
                                    } // HStack - Bars
                                    
                                    HStack(alignment: .bottom, spacing: barSpacing) {
                                        ForEach(0..<days.count, id: \.self) { index in
                                            Text(days[index]) // value.day
                                                .frame(width: self.textBoxWidth,
                                                       height: self.textBoxHeight)
                                                .font(.system(size: 10))
                                                .opacity(0.7)
                                                .foregroundColor((selectedDay - 1) == index ? .lightBlue: .primary)
                                                .lineLimit(1)
                                                .shadow(radius: 5)
                                            
                                        } // forEach
                                        .padding(.horizontal, horizontalPadding)
                                    } // HStack
                                    
                                } // VStack
                            }
                            else {
                                Text("No entries found")
                            }
                        }
                        
                        , alignment: .bottom )
                    
                    .onAppear {
                        getBeginingAndEndOfCurrentWeek()
                        hideVomitGraph = userDefaults.hideVomitGraph()
                        switch hideVomitGraph {
                        case true:
                            entryTypes = [.pee, .poop, .food, .water]
                        case false:
                            entryTypes = [.pee, .poop, .vomit, .food, .water]
                            
                        }
                        
                        
                    }
                    .onChange(of: bathroomBreak.bathroomEntries) { (_) in
                        bathroomBreak.fetchAll()
                        getBeginingAndEndOfCurrentWeek()
                    }
                    .onChange(of: selectedDog) { (_) in
                        getBeginingAndEndOfCurrentWeek()
                    }
                    .onChange(of: selectedEntryType) { (_) in
                        getBeginingAndEndOfCurrentWeek()
                    }
                
                
            } else {
                // Fallback on earlier versions
            } // overlay - background
        }
        
    } // body
    
    
    
    
} // BathroomUsageGraph

//struct BathroomUsageGraph_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            BathroomUsageGraph()
//        }
//        .preferredColorScheme(.dark)
//        .previewLayout(.sizeThatFits)
//
//        Group {
//            BathroomUsageGraph(values: [1, 0, 3, 2, 0, 1, 1 ] )
//        }
//        .preferredColorScheme(.dark)
//        .previewLayout(.sizeThatFits)
//    }
//}
