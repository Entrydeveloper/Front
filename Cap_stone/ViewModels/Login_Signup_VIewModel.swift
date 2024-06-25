//
//  SignupVIewModel.swift
//  Cap_stone
//
//  Created by 박성민 on 4/22/24.
//

import Foundation
import SwiftUI
import Alamofire
import SwiftKeychainWrapper
 
class SignupViewModel: ObservableObject {
    @Published var user: Signup
    @Published var showAlert = false
    @Published var SignupSuccess = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    private var url = "http://54.180.226.0:3000"
    
    init() {
        self.user = Signup(id: "", email: "", password: "", passwordcheck: "")
    }
    
    func signup() {
        if user.password != user.passwordcheck {
            alertTitle = "오류"
            alertMessage = "비밀번호가 일치하지 않습니다."
            showAlert = true
            return
        }
        
        if user.id.isEmpty || user.email.isEmpty {
            alertTitle = "오류"
            alertMessage = "이름 또는 아이디가 비어 있습니다."
            showAlert = true
            return
        }
        
        let parameters: [String: Any] = [
            "username": user.id,
            "password": user.password,
            "email": user.email
        ]
        
        AF.request("\(url)/users/signup", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: SignupResponse.self) { response in
                switch response.result {
                case .success(let signupResponse):
                    self.alertTitle = signupResponse.success ? "성공" : "오류"
                    self.alertMessage = signupResponse.success ? "회원가입에 성공하였습니다." : "회원가입에 실패하였습니다."
                    self.SignupSuccess = true
                case .failure(let error):
                    self.alertTitle = "오류"
                    self.alertMessage = "회원가입에 실패하였습니다. \(error.localizedDescription)"
                }
                self.showAlert = true
            }
    }
}


class LoginViewModel: ObservableObject{
    @Published var user : Login
    @Published var isLoggedIn = false
    @Published var destinationView : HomeView?
    @Published var alerterror = false
    private var url = "http://54.180.226.0:3000"
    
    init(){
        self.user = Login(id: "", password: "")
    }
    
    func login() {
        let parameters: [String: Any] = [
            "username": user.id,
            "password": user.password
        ]
        AF.request("\(url)/auth/signIn", method: .post, parameters: parameters, encoding:JSONEncoding.default)
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let loginResponse):
                    if loginResponse.success {
                        print("로그인 성공")
                        self.isLoggedIn = true
                        self.destinationView = HomeView()
                        KeychainWrapper.standard.set(loginResponse.token, forKey: "Token")
                    } else {
                        print("로그인 실패: 토큰이 없습니다.")
                        self.alerterror = true
                    }
                        case .failure(let error):
                            print("로그인 실패: \(error.localizedDescription)")
                }
            }
    }
}

struct SignupResponse: Codable {
    let success: Bool
}

struct LoginResponse: Decodable {
    let success: Bool
    let token: String
}
