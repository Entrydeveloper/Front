//
//  MypageView.swift
//  Cap_stone
//
//  Created by 박성민 on 4/23/24.
//

import SwiftUI

struct MypageView: View {
    @StateObject private var viewModel = MyPageViewModel()
    
    var body: some View {
        VStack {
            Image("user_profil")
                .resizable()
                .frame(width: 100,height: 100)
            if let userData = viewModel.userData{
                Text(userData.username)
                    .font(.system(size: 23))
                    .padding()
            } else {
                Text("잠시만 기다려 주세요")
            }
        }
        .onAppear {
            viewModel.fetchUserId()
        }
    }
}


#Preview {
    MypageView()
}
