//
//  SignupVIewModel.swift
//  Cap_stone
//
//  Created by 박성민 on 4/22/24.
//

import Foundation
import SwiftUI

class SignupViewModel: ObservableObject{
    @Published var user : Signup
    
    init(){
        self.user = Signup(name: "", id: "", password: "", passwordcheck: "")
    }
    
    func signup(){
        print("회원가입 성공")
    }
}

class LoginViewModel: ObservableObject{
    @Published var user : Login
    @Published var isLoggedIn = false
    @Published var destinationView : HomeView?
    
    init(){
        self.user = Login(id: "", password: "")
    }
    
    func login() {
            print("로그인 성공")
            isLoggedIn = true
            destinationView = HomeView()
    }
}
