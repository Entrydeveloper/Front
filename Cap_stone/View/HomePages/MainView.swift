//
//  MainView.swift
//  Cap_stone
//
//  Created by 박성민 on 4/23/24.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @EnvironmentObject private var themeManager: ThemeManager
    var body: some View {
        VStack{
            MainViewTitle("위클 행사 정보")
            Image(systemName: "photo")
                .resizable()
                .frame(width: 290,height: 300)
                .padding(.bottom,30)
            MainViewTitle("익명 상담하기")
            CounselingButton("또래상담사와", "채팅하기") {
                viewModel.teacherCounselor()
            }
            CounselingButton("위클쌤과","상담하기"){
                viewModel.studentCounselor()
            }
            Spacer()
        }
    }
}

#Preview {
    MainView()
        .environmentObject(ThemeManager())
}

