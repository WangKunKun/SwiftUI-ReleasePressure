//
//  ShapePage.swift
//  ReleasePressure
//
//  Created by 王琨 on 2023/7/22.
//

import Foundation
import SwiftUI
struct MagicShapePage: View {
    @State private var sides: Double = 4
    
    
    var body: some View {
        VStack {
            MagicShape(sides: sides, scale: 1)
                .stroke(Color.pink, lineWidth: (sides < 3) ? 10 : ( sides < 7 ? 5 : 2))
                .padding(20)
                .animation(.easeInOut(duration: 3.0), value: sides)
                .layoutPriority(1)
            
            
            Text("\(Int(sides)) 条边")
            
            Slider(value: $sides, in: 0...20)
            
            HStack(spacing: 20) {
                
                MyButton(label: "3") {
                    self.sides = 3.0
                }
                
                MyButton(label: "7") {
                    self.sides = 7.0
                }
                
                MyButton(label: "15") {
                    self.sides = 15.0
                }
                
                
            }
        }.navigationBarTitle("MagicShape").padding(.bottom, 50)
    }
}
