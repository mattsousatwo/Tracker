//
//  NavBar.swift
//  NavBar
//
//  Created by Matthew Sousa on 9/10/21.
//  Copyright © 2021 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct NavBar<Left, Center, Right>: View where Left: View, Center: View, Right: View {
    let left: () -> Left
    let center: () -> Center
    let right: () -> Right
    init(@ViewBuilder left: @escaping () -> Left, @ViewBuilder center: @escaping () -> Center, @ViewBuilder right: @escaping () -> Right) {
        self.left = left
        self.center = center
        self.right = right
    }
    var body: some View {
        ZStack {
            HStack {
                left()
                Spacer()
            }
            center()
            HStack {
                Spacer()
                right()
            }
        }
    }
}

struct NavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavBar(left: { Text("Left") },
               center: { Text("Mid") },
               right: { Text("Right") })
    }
}
