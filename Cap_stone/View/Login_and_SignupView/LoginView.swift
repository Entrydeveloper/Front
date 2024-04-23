//
//  LoginView.swift
//  Cap_stone
//
//  Created by 박성민 on 4/3/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
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
                        Text("|")
                            .font(.system(size: 18))
                            .padding(.bottom,3)
                        Button{
                            
                        }label: {
                            Text("비밀번호 찾기")
                                .foregroundStyle(.black)
                        }
                        Text("|")
                            .font(.system(size: 15))
                            .padding(.bottom,3)
                        NavigationLink(destination:{
                            SignupView()
                        },label: {
                            Text("회원가입")
                                .foregroundStyle(.black)
                        })
                    }.font(.system(size: 12))
                    
                    Button{
                        viewModel.login()
                    }label: {
                        CustomButton("로그인")
                            .padding(.top,50)
                    }
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
