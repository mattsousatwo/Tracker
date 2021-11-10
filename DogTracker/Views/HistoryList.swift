//
//  HistoryList.swift
//  DogTracker
//
//  Created by Matthew Sousa on 11/9/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

@available (iOS 14.0, *)
struct HistoryList<Content: View>: View {
    
    let dateControllerProvider = DateControllerProvider()
    let formatter = DateFormatter()
    
    @Binding var firstDate: Date
    @Binding var lastDate: Date
    /// Should be an empty array to contain what dates the provider will produce
    @Binding var currentWeek: [String]
    var size: DateController.DateControllerSize = .large
    @Binding var fetchCurrentWeekOnAppear: Bool
    @Binding var elementesCount: Int
    @Binding var title: String
    
    /// Background Colors
    @Environment(\.colorScheme) var colorScheme
    @State private var backgroundColor: Color = .backgroundGray
    
    var displayFilterButton: Bool = false
    
    // List to be passed in
    @ViewBuilder var content: Content
    
    var body: some View {
        ZStack {
            
            backgroundColor
                .ignoresSafeArea()
                .onAppear {
                    setBackgroundColorOnAppear()
                    
                    switch fetchCurrentWeekOnAppear {
                    case true:
                        break
                    case false:
                        currentWeek = dateControllerProvider.weekOf(the: firstDate)
                    }
                    
                }
                .onChange(of: colorScheme) { _ in
                    updateBackgroundColor()
                }

            
            
            
            VStack {
                dateController()
                List {
                    content
                        .padding()
                }
                HStack {
                    Spacer()
                    Text(elementesCount != 0 ? "Entries for week: \(elementesCount)": "").italic()
                        .fontWeight(.light)
                    Spacer()
                }
                .padding()
                
            }
            
            .navigationTitle( Text(title) )
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if displayFilterButton == true {
                        filterButton()
                    }
                }
                
            }
            
            
            
        }
        
    }
    
    
}

@available (iOS 14.0, *)
extension HistoryList {
    
    func filterButton() -> some View {
        Button {
            
        } label: {
            Text("Filter")
                .bold()
        }
        
    }
}

// Date Controller
@available (iOS 14.0, *)
extension HistoryList {
    
    /// Date Controller
    func dateController() -> some View {
        return DateController(firstDate: $firstDate,
                              lastDate: $lastDate,
                              size: size,
                              fetchCurrentWeekOnAppear: $fetchCurrentWeekOnAppear)
    }
    
}

// Background Color Handling
@available (iOS 14.0, *)
extension HistoryList {
    
    /// Change background color on appear of view
    func setBackgroundColorOnAppear() {
        switch colorScheme {
        case .light:
            backgroundColor = .backgroundGray
        case .dark:
            backgroundColor = .black
        default:
            backgroundColor = .backgroundGray
        }
    }
    
    /// Change background color when color scheme changes
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

    
}


@available(iOS 14.0, *)
struct HistoryList_Previews: PreviewProvider {
    static var previews: some View {
        HistoryList(firstDate: .constant(Date()),
                    lastDate: .constant(Date()),
                    currentWeek: .constant([]),
                    fetchCurrentWeekOnAppear: .constant(false),
                    elementesCount: .constant(1),
                    title: .constant("New Title")) {
            Text("Hello World!")
        }

    }
}
