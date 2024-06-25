//
//  JWTcheck.swift
//  Cap_stone
//
//  Created by 박성민 on 6/21/24.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

func fetchUserData() {
    guard let token = KeychainWrapper.standard.string(forKey: "token") else{
        print("토큰이 없습니다.")
        return
    }
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer \(token)"
    ]
}
