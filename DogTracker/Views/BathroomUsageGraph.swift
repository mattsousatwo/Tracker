//
//  BathroomUsageGraph.swift
//  DogTracker
//
//  Created by Matthew Sousa on 3/5/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI
import Dispatch

/// Layered bar graph to show
struct BathroomUsageGraph: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var bathroomBreak = BathroomBreak()
    @ObservedObject var dogs = Dogs()
    @ObservedObject var foodEntries = FoodEntries()
    @ObservedObject var userDefaults = UserDefaults()
    
    let dateControllerProvider = DateControllerProvider()
    
    @Binding var selectedDog: Dog
    @State var selectedDogName: String = "Select a dog"
    
    // size
    var width: CGFloat = UIScreen.main.bounds.width - 20
    var height: CGFloat = 300
    
    // Coloring
    @State private var backgroundColor: Color = .white
    var barColors: [Color] = [.lightBlue, .azure, .darkBlue]
    
    // Content
    var values: [CGFloat] = [0, 0, 3, 0, 0, 0, 0 ]
    var days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @State private var valueIncrements: [String] = ["6", "5", "4", "3", "2", "1", ""]
    @State private var bathroomEntries: [BathroomEntry] = []
    @State private var fetchCurrentWeek: Bool = true
    
    // Configuration
    var barSpacing: CGFloat = 8 // HStack alignment spacing
    var horizontalPadding: CGFloat = 8 // Horizontal padding for each bar
    var textBoxWidth: CGFloat = 30 // width for textbox
    var textBoxHeight: CGFloat = 30 // width for textbox
    
    /// Update background color depending on colorScheme
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

    /// Update background color depending on colorScheme when view appears
    func updateBackgroundColorOnAppear() {
        switch colorScheme {
        case .dark:
            backgroundColor = .black
        case .light:
            backgroundColor = .backgroundGray
        default:
            backgroundColor = .backgroundGray
        }
    }
    
    
    
    @State private var currentWeek: String = "Current Week"
    
    @State private var graphElements: [GraphElement]?
    
    
    @State private var firstDate: Date = Date()
    @State private var lastDate: Date = Date()
    
    func getFirstAndLastOfWeek() -> (first: String, last: String)? {
        
        let days = dateControllerProvider.unformattedWeekOf(the: firstDate)
        
        guard let firstDay = days.first else { return nil }
        let firstDayString = dateControllerProvider.graphDateFormat(firstDay)
        
        guard let lastDay = days.last else { return nil }
        let lastDayString = dateControllerProvider.graphDateFormat(lastDay)
        
        return (first: firstDayString, last: lastDayString)
    }
    
    func updateCurrentWeek(_ first: String, _ last: String) {
        currentWeek = "\(first) - \(last)"
    }
    
    func getBeginingAndEndOfCurrentWeek() {
        if let favoriteDog = dogs.getFavoriteDog() {
            selectedDog = favoriteDog
        }
        
        let firstAndLastDates = getFirstAndLastOfWeek()
        
        if let graphWeekDates = firstAndLastDates {
            updateCurrentWeek(graphWeekDates.first, graphWeekDates.last)
        }
        
        
        let days = dateControllerProvider.unformattedWeekOf(the: firstDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        var formattedDatesContainer: [String] = []
        for day in days {
            formattedDatesContainer.append(formatter.string(from: day))
        }
            getGraphElements(for: selectedDog, in: formattedDatesContainer, of: selectedEntryType)
    }
    
    func convertToStringArray(dates: [Date]) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        var formattedDatesContainer: [String] = []
        for day in dates {
            formattedDatesContainer.append(formatter.string(from: day))
        }
        return formattedDatesContainer
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
                setHighestEntryValue()
            }
        case .food, .water:
            if let foodElements = foodEntries.getEntries(in: week, for: dog, ofType: type) {
                let elements = foodEntries.convertFoodEntriesToGraphElements(foodElements)
                for element in elements {
                    print("\(element.day), \(element.foodEntries)")
                }
                graphElements = []
                graphElements = elements
                setHighestEntryValue()
                if let graphElements = graphElements {
                    print("\n GraphElements")
                    for element in graphElements {
                        print("\(element.day), \(element.foodEntries)")
                    }
                }
            }
        }
        
    }
    
    
    func setHighestEntryValue() {
        var values: [Int] = []
        
        if let graphElements = graphElements {
            for element in graphElements {
                switch selectedEntryType {
                case .pee, .poop, .vomit:
                    values.append(element.bathroomEntries.count)
                case .food, .water:
                    values.append(element.foodEntries.count)
                }
            }
        }
        
        values.sort { $0 > $1}
        if let highest = values.first {
            highestEntryValue = highest
        }
        
        let blank = ""
        
        switch highestEntryValue {
        case 0...6:
            valueIncrements = ["6", "5", "4", "3", "2", "1", blank]
        case 7...12:
            valueIncrements = ["12", "10", "8", "6", "4", "2", blank]
        case 13...18:
            valueIncrements = ["18", "15", "12", "9", "6", "3", blank]
        default:
            valueIncrements = ["6", "5", "4", "3", "2", "1", blank]
        }
        
        print("HighestEntryValue: \(highestEntryValue)")
        
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
        func onesEquation() -> CGFloat {
            return CGFloat(((value - 1) * 45) + 20)
        }
        
        func twosEquation() -> CGFloat {
            let y = Double(value)
            return CGFloat(((y - 2.0) * 22.5) + 20.0)
        }
        
        func threesEquation() -> CGFloat {
            return CGFloat(((value - 3) * 15) + 20)
        }
        
        var x: CGFloat = 0
        
        switch highestEntryValue {
        case 0...6:
            x = onesEquation()
        case 7...12:
            switch value {
            case 1:
                x = 10
            default:
                x = twosEquation()
            }
        case 13...18:
            switch value {
            case 1:
                x = 10
            case 2:
                x = 15
            default:
                x = threesEquation()
            }
        default:
            x = 0
            
        }
        
        
        return x
    }
    
    @State private var highestEntryValue: Int = 0
    
    @State private var discreteMode: Bool = false
    
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
    
    
    
    @State private var graphWeek = Date().asFormattedString()
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                
                if #available(iOS 14.0, *) {
                    
                    switch discreteMode {
                    case true:
                        if selectedEntryType == .pee ||
                            selectedEntryType == .poop ||
                            selectedEntryType == .vomit {
                            Text("\(selectedEntryType.discreteMode!):").font(.system(size: 25,
                                                                                     weight: .medium,
                                                                                     design: .rounded))
                        } else {
                            Text("\(selectedEntryType.rawValue):").font(.system(size: 25,
                                                                                weight: .medium,
                                                                                design: .rounded))
                        }
                    case false:
                        Text("\(selectedEntryType.rawValue):").font(.system(size: 25,
                                                                            weight: .medium,
                                                                            design: .rounded))
                    }
                    
                    
                    
                    
                    Spacer()
                    
                    DateController(firstDate: $firstDate,
                                   lastDate: $lastDate,
                                   size: .small,
                                   fetchCurrentWeekOnAppear: $fetchCurrentWeek)
                    .onAppear {
                        if let name = selectedDog.name {
                            selectedDogName = name
                        }
                        getCurrentWeekday()
                        discreteMode = userDefaults.discreetMode()
                                        }
                    .onChange(of: selectedDog, perform: { value in
                        if let name = selectedDog.name {
                            selectedDogName = name
                        }
                    })
                    
                }
                
            }
            // Background
            if #available(iOS 14.0, *) {
                backgroundColor
                    .onTapGesture {
                        cycleThroughEntryTypes()
                    }
                    .onAppear {
                        updateBackgroundColorOnAppear()
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
                        
                        DispatchQueue.global(qos: .userInteractive).async {
                            bathroomBreak.fetchAll()
                            getBeginingAndEndOfCurrentWeek()
                        }
                    }
                    .onChange(of: selectedDog) { (_) in
                        getBeginingAndEndOfCurrentWeek()
                    }
                    .onChange(of: selectedEntryType) { (_) in
                        getBeginingAndEndOfCurrentWeek()
                    }
                    .onChange(of: firstDate, perform: { value in
                        getBeginingAndEndOfCurrentWeek()
                    })
                
                
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


extension BathroomUsageGraph {
    
    // GraphWeek
    
    /// Change graph to current week
    private func setToCurrentDate() {
        let formatter = DateFormatter()
        let today = Date()
        guard let plusOneWeek = today.addOneWeek() else { return }
        firstDate = today
        updateCurrentWeek(formatter.graphDateFormat(today),
                          formatter.graphDateFormat(plusOneWeek))
        
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
                    .frame(width: 25, height: 25, alignment: .center)
                    .foregroundColor(.gray)
            }.buttonStyle(PlainButtonStyle() )
    }
    
}
