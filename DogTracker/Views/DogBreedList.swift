//
//  DogBreedList.swift
//  DogTracker
//
//  Created by Matthew Sousa on 6/15/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct DogBreedList: View {
    
    @State private var displayToggle: Bool = false
    @State private var editingMode: Bool = false
    
    @Binding var breeds: [String]
    
    var body: some View {
        
        VStack(alignment: .leading) {
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
                            
//                            .rotationEffect(displayToggle ? .degrees(90) : .degrees(0),
//                                            anchor: .center)
                            .rotationEffect(.degrees(displayToggle ? 90 : 0), anchor: .center)
                            .animation(displayToggle ? .easeIn : nil)
                            
//                            .animation(displayToggle ? .default : nil )

                            
//                            .transition(displayToggle ? .pivot : .identity)
//                            .transition(.identity)
//                            .animation(.default)
                        
                    } else if editingMode == true {
                        
                        cancelButton()
                    }
                }
                .buttonStyle(PlainButtonStyle() )
            }
            .foregroundColor(.black)
            .padding()
            
            if displayToggle == true {
                Divider()
                ForEach(0..<breeds.count, id: \.self) { i in
                    HStack {
                        if editingMode == true {
                            
                            minusButton(removeAtIndex: i)
                        }
                        Text(breeds[i])
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
                        breeds.remove(at: i)
                    }
                }
            }
            .animation(.default, value: breeds)
    }
    
    func breedsTitle() -> some View {
        return HStack {
            Text("Breeds").font(.subheadline)
                .padding(.leading, 10)
                .padding(.vertical, 10)
        
            Text("\(breeds.count)").font(.subheadline)
                .foregroundColor(.gray)
        }
    }
    
    func menuIndicator() -> some View {
        return
            Image(systemName: "chevron.right")
            .frame(width: 20, height: 20)
            .padding(5)
//            .rotationEffect(displayToggle ? .degrees(90) : .degrees(0),
//                            anchor: .center)
//            .animation(.default)
//            .animation(displayToggle ? .default : nil)
    }
    
    func cancelButton() -> some View {
        return
            Button {
                self.editingMode = false
            } label: {
                Text("Cancel")
                    .bold()
                    .foregroundColor(.red)
            }
    }
    
}

struct DogBreedList_Previews: PreviewProvider {
    static var previews: some View {
        DogBreedList(breeds: .constant(["Pomeranian", "German Shepard"]))
    }
}


struct RotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: anchor).clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(active: RotateModifier(amount: -90, anchor: .center),
                  identity: RotateModifier(amount: 0, anchor: .center))
    }
}
