//
//  ColorPickerView.swift
//  Cap_stone
//
//  Created by 박성민 on 6/12/24.
//

import SwiftUI

struct ColorPickerView: View {
    @ObservedObject var viewModel: ChatViewModel
    @EnvironmentObject var themeManager: ThemeManager
        var body: some View {
            VStack(spacing: 20) {
                ForEach(viewModel.colors) { colorOption in
                    ColorCircleView(color: colorOption.color)
                        .onTapGesture {
                            selectColor(colorOption.color)
                        }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 10)
        }
    private func selectColor(_ color: Color) {
        themeManager.selectedColor = color
        viewModel.toggleColorPicker()
    }
}

struct ColorCircleView: View {
    var color: Color

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 30, height: 30)
    }
}

#Preview{
    ColorPickerView(viewModel: ChatViewModel()) // viewModel 설정
}
