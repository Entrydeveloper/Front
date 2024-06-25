//
//  LoginView.swift
//  Cap_stone
//
//  Created by 박성민 on 4/3/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    Image("logo_and_weesh")
                        .resizable()
                        .frame(width: 250,height: 250)
                        .padding(.bottom,20)
                    CustomTextFeild($viewModel.user.id, "아이디를 입력해주세요")
                    DividerView()
                    CustomSecureField($viewModel.user.password, "비밀번호를 입력해주세요")
                    DividerView()
                    HStack{
                        Button{
                            
                        }label: {
                            Text("아이디 찾기")
                                .foregroundStyle(.black)
                        }
                        Divider()
                            .frame(width: 1,height: 20)
                            .background(Color.black)
                        Button{
                            
                        }label: {
                            Text("비밀번호 찾기")
                                .foregroundStyle(.black)
                        }
                        Divider()
                            .frame(width: 1,height: 20)
                            .background(Color.black)
                        NavigationLink(destination:{
                            SignupView()
                        },label: {
                            Text("회원가입")
                                .foregroundStyle(.black)
                        })
                    }.font(.system(size: 12))
                    Button(action: {
                        viewModel.login()
                    }){
                        CustomButton("로그인")
                            .padding(.top, 50)
                    }.navigationDestination(isPresented: $viewModel.isLoggedIn) {
                        viewModel.destinationView
                    }.alert(isPresented: $viewModel.alerterror){
                        Alert(title: Text("로그인 실패"),
                        message: Text("아이디와 비밀번호가 일치하지 않습니다"),
                        dismissButton: .default(Text("확인")))
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    LoginView()
        .environmentObject(ThemeManager())
}
