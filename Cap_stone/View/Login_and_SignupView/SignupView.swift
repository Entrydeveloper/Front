//
//  SignupView.swift
//  Cap_stone
//
//  Created by 박성민 on 4/3/24.
//

import SwiftUI

struct SignupView: View {
    @StateObject var viewModel = SignupViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    Image("logo_and_weesh")
                        .resizable()
                        .frame(width: 250,height: 250)
                        .padding(.bottom,20)
                    CustomTextFeild($viewModel.user.id, "아이디")
                    DividerView()
                    CustomTextFeild($viewModel.user.email, "이메일")
                    DividerView()
                    CustomSecureField($viewModel.user.password, "비밀번호")
                    DividerView()
                    CustomSecureField($viewModel.user.passwordcheck, "비밀번호 확인")
                    DividerView()
                    
                    Button{
                        viewModel.signup()
                    }label:{
                        CustomButton("가입하기")
                    }.alert(isPresented: $viewModel.showAlert) {
                        Alert(title: Text(viewModel.alertTitle),
                              message: Text(viewModel.alertMessage),
                              dismissButton: .default(Text("확인")))
                    }
                    NavigationLink(destination: LoginView(), isActive: $viewModel.SignupSuccess) {
                        EmptyView()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    SignupView()
}
