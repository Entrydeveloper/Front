//
//  ColorOption.swift
//  Cap_stone
//
//  Created by 박성민 on 6/12/24.
//

import SwiftUI
import Foundation

struct ColorOption: Identifiable {
    let id = UUID()
    let color: Color
    
    init(red: Double, green: Double, blue : Double){
        self.color = Color(red: red/255,green: green / 255, blue: blue/255)
    }
}
