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
    
    init(_ title: String){
        self.title = title
    }
    var body: some View{
        Text(title)
            .foregroundStyle(Color(red: 134 / 255, green: 194 / 255, blue: 99 / 255))
            .font(.system(size: 32))
            .fontWeight(.bold)
            .padding(.trailing,110)
    }
}

struct CounselingButton: View{
    
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
                    .background(Color(red: 76 / 255, green:160 / 255, blue: 28/255, opacity: 0.6))
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
