//
//  HomeView.swift
//  Cap_stone
//
//  Created by 박성민 on 4/23/24.
//

import SwiftUI

struct HomeView: View {
    @State private var selection = 2
    var body: some View {
        NavigationStack{
            ZStack{
                TabView(selection: $selection){
                    musicView()
                        .tabItem {
                            Image(systemName: "music.note.list")
                        }
                        .tag(1)
                    MainView()
                        .tabItem {
                            Image(systemName: "house")
                        }
                        .tag(2)
                    ChatView()
//                       .badge("!") 이거 메세지에 쓰기
                        .tabItem {
                            Image(systemName: "ellipsis.message")
                        }
                        .tag(3)
                    MypageView()
                        .tabItem {
                            Image(systemName: "person")
                        }
                        .tag(4)
                }
                .accentColor(Color.black) // 선택된 아이콘 색깔
                .navigationBarBackButtonHidden()
                Divider()
                    .padding(.top,600)
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(ThemeManager())
}
