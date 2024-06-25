//
//  Cap_stoneApp.swift
//  Cap_stone
//
//  Created by 박성민 on 4/3/24.
//

import SwiftUI

@main
struct Cap_stoneApp: App {
    @StateObject private var imageData = ImageData()
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(imageData)
                .environmentObject(ThemeManager())
        }
    }
}
