//  ContentView.swift
//  Cap_stone
//
//  Created by 박성민 on 4/3/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ContentView()
}
