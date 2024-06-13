//
//  ChatView.swift
//  Cap_stone
//
//  Created by 박성민 on 4/23/24.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                HStack {
                    Text("채팅")
                        .padding([.top, .leading], 40)
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.selectedColor)
                    Spacer()
                    Button(action: {
                        viewModel.toggleColorPicker()
                    }) {
                        Image(systemName: "paintbrush.fill")
                            .padding([.top, .trailing], 40)
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                    }
                }
                Spacer()
            }
            if viewModel.showColorPicker {
                ColorPickerView(viewModel: viewModel)
                    .padding(.trailing, 25)
                    .offset(y: 80)
                    .transition(.opacity.combined(with: .scale))
                    .animation(.easeInOut, value: viewModel.showColorPicker)
            }
        }
    }
}

#Preview {
    ChatView()
        .environmentObject(ThemeManager())
}

