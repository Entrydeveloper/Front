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
            VStack{
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
            }
        }
    }
}

#Preview {
    HomeView()
}
