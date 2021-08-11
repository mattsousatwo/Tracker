//
//  DateController.swift
//  DogTracker
//
//  Created by Matthew Sousa on 7/30/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct DateController: View {
    
    @State private var currentWeek: String = "Current Week"
    @Binding var firstDate: Date
    @Binding var lastDate: Date
    let formatter = DateFormatter()
    var size: DateControllerSize
    
    var body: some View {
        HStack {
            changeDateButton(.left)
                .padding()
            
            Button {
                getBeginingAndEndOfCurrentWeek()
            } label: {
                Text(currentWeek)
                    .font(.system(size: size.textSize,
                                  weight: .medium,
                                  design: .rounded))
                     .padding()
            }.buttonStyle(PlainButtonStyle() )
            
            
            changeDateButton(.right)
                .padding()
        }
        .onAppear {
            getBeginingAndEndOfCurrentWeek()
        }
    }
    
    // Button types for controller buttons
    enum DateButtonType {
        case left
        case right
        
        var image: Image {
            switch self {
            case .left:
                return Image(systemName: "arrow.left.circle.fill")
            case .right:
                return Image(systemName: "arrow.right.circle.fill")
            }
        }
    }
    
    enum DateControllerSize {
        case small
        case large
        
        var textSize: CGFloat {
            switch self {
            case .small:
                return 15
            case .large:
                return 25
            }
        }
        
        var buttonSize: CGFloat {
            switch self {
            case .small:
                return 25
            case .large:
                return 30
            }
        }

    }
    
    func updateCurrentWeek(_ first: Date, _ last: Date) {
        firstDate = first
        lastDate = last
        
        let firstFormattedDate = formatter.graphDateFormat(first)
        let lastFormattedDate = formatter.graphDateFormat(last)
        
        currentWeek = "\(firstFormattedDate) - \(lastFormattedDate)"
    }
    
    
    
    func moveOverOneWeek(_ selection: DateButtonType) {
        switch selection {
        case .left:
            guard let rightDate = firstDate.subtractOneDay() else { return }
            
            let subtractedDatesRange = getDatesRangeForWeekOf(rightDate)
            guard let first = subtractedDatesRange.first else { return }
            guard let last = subtractedDatesRange.last else { return }
            
            updateCurrentWeek(first, last)
            
        case .right:
            guard let leftDate = lastDate.addOneDay() else { return }
            
            let addedDatesRange = getDatesRangeForWeekOf(leftDate)
            guard let first = addedDatesRange.first else { return }
            guard let last = addedDatesRange.last else { return }
            
            updateCurrentWeek(first, last)
        }
    }
    
    // Button to change the date
    private func changeDateButton(_ direction: DateButtonType) -> some View {
        
        let frame = size.buttonSize
        
        return
            Button {
                moveOverOneWeek(direction)
            } label: {
                direction.image
                    .resizable()
                    .frame(width: frame,
                           height: frame,
                           alignment: .center)
                    .foregroundColor(.gray)
            }.buttonStyle(PlainButtonStyle() )
    }

    func getBeginingAndEndOfCurrentWeek() {
        let days = getDatesRangeForWeekOf(Date() )
        
        guard let firstDay = days.first else { return }
        guard let lastDay = days.last else { return }
        
        
        updateCurrentWeek(firstDay,
                          lastDay)
    }
    
    // Will get the range to the
    func getDatesRangeForWeekOf(_ date: Date? = nil) -> [Date] {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        
        
        var selectedDate: Date?
        
        if let date = date {
            selectedDate = date
        } else {
            selectedDate = firstDate
        }
        
        guard let selected = selectedDate else { return [] }
        
        let today = calendar.startOfDay(for: selected)
        
        let dayOfTheWeek = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound )
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfTheWeek, to: today)}
        return days
    }
    
    // Get the first and last dates
    func getFirstAndLastOfWeek() -> (first: String, last: String)? {
        
        let days = getDatesRangeForWeekOf()
        
        guard let firstDay = days.first else { return nil }
        let firstDayString = formatter.graphDateFormat(firstDay)
        
        guard let lastDay = days.last else { return nil }
        let lastDayString = formatter.graphDateFormat(lastDay)
        
        return (first: firstDayString, last: lastDayString)
    }
}

//struct DateController_Previews: PreviewProvider {
//    static var previews: some View {
//        DateController().previewLayout(.sizeThatFits)
//    }
//}
