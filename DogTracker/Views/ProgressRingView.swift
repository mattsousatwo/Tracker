//
//  ProgressRingView.swift
//  ActivityRing
//
//  Created by Matthew Sousa on 8/29/20.
//  Copyright © 2020 Matthew Sousa. All rights reserved.
//

import SwiftUI

struct ProgressRingView: View {
    
    // Ring Thickness
    var thickness: CGFloat = 30.0
    // Frame Width
    @Binding var width: CGFloat
    // Colors used [ finish(darker), start(lighter) ]
    var gradient = Gradient(colors: [.lightBlue, .darkBlue])
    
    var startAngle = -90.0
    
    @Binding var progress: Double
    
    private var radius: Double {
        Double(width / 2)
    }
    
    private var colors: Gradient {
        var grade: Gradient = Color.gradientThree
        if self.progress < 0.6 {
            grade = Gradient(colors: [Color.lightGreen, Color.darkGreen])
        } else if self.progress < 0.8 {
            grade = Gradient(colors: [Color.lightYellow, Color.darkYellow])
        } else if self.progress <= 1.0 {
            grade = Color.gradientThree
        }
        return grade
    }
    
    
    
    private func ringTipPosition(progress: Double) -> CGPoint {
        let angle = 360 * progress + startAngle
        let angleInRadian = angle * .pi / 180
        
        return CGPoint(x: radius * cos(angleInRadian),
                       y: radius * sin(angleInRadian))
    }
    
    private var ringTipShadowOffset: CGPoint {
        let shadowPosition = ringTipPosition(progress: progress + 0.01)
        let circlePosition = ringTipPosition(progress: progress)
        
        return CGPoint(x: shadowPosition.x - circlePosition.x,
                       y: shadowPosition.y - circlePosition.y)
    }
    
    
    var body: some View {
        // Creating a ZStack to layer the two circles ontop of each other
        ZStack(alignment: .center) {
            Circle()
                .stroke(Color(.systemGray6), lineWidth: thickness)
                .opacity(0.6)
                .overlay(

                    Text("1:24")
                        .font(.system(size: 60, weight: .medium, design: .rounded))
                        .foregroundColor(Color(.systemGray2))
                    .padding()

            )

            RingShape(progress: progress, thickness: thickness)
                // SETTING COLOR BY PROGRESS - progress > 0.5 ? gradient : Color.gradientOne
                .fill(AngularGradient(gradient: colors,
                                      center: .center,
                                      startAngle: .degrees(startAngle),
                                      endAngle: .degrees(360 * progress + startAngle)) )
            
            RingTip(progress: progress,
                    startAngle: startAngle,
                    ringRadius: radius)
                .frame(width: thickness, height: thickness)
                .foregroundColor(progress > 0.96 ? Color.darkRed : Color.clear )
                .shadow(color: progress > 0.96 ? Color.black.opacity(0.15) : Color.clear,
                        radius: 2,
                        x: ringTipShadowOffset.x,
                        y: ringTipShadowOffset.y)
            
            
            
            
        } // ZStack
            .frame(width: width, height: width, alignment: .center)
            .animation(Animation.easeInOut(duration: 1.0))
        
        
        
    } // Body
    
} // ProgRingView

struct ProgressRingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            ProgressRingView(width: .constant(250.0), progress: .constant(0.1)).previewLayout(.fixed(width: 300, height: 300))
            
            ProgressRingView(width: .constant(250.0), progress: .constant(0.2)).previewLayout(.fixed(width: 300, height: 300))
            
            ProgressRingView(width: .constant(250.0), progress: .constant(0.3)).previewLayout(.fixed(width: 300, height: 300))
            
            ProgressRingView(width: .constant(250.0), progress: .constant(0.4)).previewLayout(.fixed(width: 300, height: 300))
            
            ProgressRingView(width: .constant(250.0), progress: .constant(0.5)).previewLayout(.fixed(width: 300, height: 300))
            
            ProgressRingView(width: .constant(250.0), progress: .constant(0.6)).previewLayout(.fixed(width: 300, height: 300))
            
            ProgressRingView(width: .constant(250.0), progress: .constant(0.7)).previewLayout(.fixed(width: 300, height: 300))
            
            ProgressRingView(width: .constant(250.0), progress: .constant(0.8)).previewLayout(.fixed(width: 300, height: 300))
            
            ProgressRingView(width: .constant(250.0), progress: .constant(0.9)).previewLayout(.fixed(width: 300, height: 300))
            
            ProgressRingView(width: .constant(250.0), progress: .constant(1.0)).previewLayout(.fixed(width: 300, height: 300))
        }
        
        
    }
}


struct RingShape: Shape {
    var progress: Double = 0.0
    var thickness: CGFloat = 30.0
    
    var startAngle: Double = -90.0
    
    var animatableData: Double {
        get { progress }
        set {progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        path.addArc(center: CGPoint(x: rect.width / 2.0, y: rect.height / 2.0),
                    radius: min(rect.width, rect.height) / 2.0,
                    startAngle: .degrees(startAngle),
                    endAngle: .degrees(360 * progress + startAngle),
                    clockwise: false)
        
        return path.strokedPath(.init(lineWidth: thickness, lineCap: .round))
    }
    
    
} // RingShape


struct RingTip: Shape {
    var progress: Double = 0.0
    var startAngle: Double = -90.0
    var ringRadius: Double
    
    private var position: CGPoint {
        let angle = 360 * progress + startAngle
        let angleInRadian = angle * .pi / 180
        
        return CGPoint(x: ringRadius * cos(angleInRadian),
                       y: ringRadius * sin(angleInRadian))
    }
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        guard progress > 0.0 else {
            return path
        }
        
        let frame = CGRect(x: position.x,
                           y: position.y,
                           width: rect.size.width,
                           height: rect.size.height)
        
        path.addRoundedRect(in: frame, cornerSize: frame.size)
        
        return path
    }
    
    
    
    
}


struct GradientText: View {
    
    
    var title: String
    var size: CGFloat
    var gradient: Gradient
    
    var body: some View {
        RadialGradient(gradient: gradient,
                       center: .center,
                       startRadius: 0,
                       endRadius: 250)
                .frame(width: size, height: size)
            .mask(
                Text(title)
                        .font(.system(size: 50, weight: .medium, design: .rounded))
                        .foregroundColor(Color(.systemGray2))
                    .padding()
            )
    }
    
}
