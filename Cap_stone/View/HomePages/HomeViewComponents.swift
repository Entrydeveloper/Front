//
//  HomeViewComponents.swift
//  Cap_stone
//
//  Created by 박성민 on 5/25/24.
//

import Foundation
import SwiftUI

struct MainViewTitle: View{
    var title: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    init(_ title: String){
        self.title = title
    }
    var body: some View{
        Text(title)
            .foregroundStyle(themeManager.selectedColor)
            .font(.system(size: 32))
            .fontWeight(.bold)
            .padding(.trailing,110)
    }
}

struct CounselingButton: View{
    @EnvironmentObject private var themeManager: ThemeManager
    
    let counselingText: String
    let subText: String
    var action: () -> Void
    
    init(_ counselingText: String, _ subText: String, action: @escaping () -> Void){
        self.counselingText = counselingText
        self.subText = subText
        self.action = action
    }
    var body: some View{
        HStack{
            VStack{
                Text(counselingText)
                Text(subText)
            }
            .font(.system(size: 25))
            .fontWeight(.bold)
            .padding(.top,5)
            Spacer()
            Button(action: action){
                Text("상담하기")
                    .font(.system(size: 23))
                    .padding(10)
                    .foregroundStyle(Color.white)
                    .fontWeight(.bold)
                    .background(themeManager.selectedColor)
                    .cornerRadius(30)
                
            }
        }
        .frame(width: 260)
        .padding()
        .cornerRadius(10.0)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 1)
        )
    }
}
