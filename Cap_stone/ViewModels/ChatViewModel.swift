//
//  ChatViewModel.swift
//  Cap_stone
//
//  Created by 박성민 on 6/12/24.
//

import Foundation
import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var showColorPicker = false

    @Published var colors: [ColorOption] = [
        ColorOption(red:255,green:205,blue:234),
        ColorOption(red:249,green:232,blue:151),
        ColorOption(red:210,green:227,blue:200),
        ColorOption(red:57,green:167,blue:255),
        ColorOption(red:181,green:41,blue:230)
    ]
    
    func toggleColorPicker() {
        withAnimation {
            showColorPicker.toggle()
        }
    }
}

class ThemeManager: ObservableObject {
    @Published var selectedColor: Color
        
    init() {
        self.selectedColor = Color(red: 210 / 255, green: 227 / 255, blue: 200 / 255)
    }
}
