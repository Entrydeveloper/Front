import Foundation
import Alamofire
import SwiftKeychainWrapper

class MainViewModel: ObservableObject {
    @Published var userId: Int?
    @Published var userData: UserResponse.UserBody?

    private var url = "http://54.180.226.0:3000"
    
    func fetchUserId() {
        guard let token = KeychainWrapper.standard.string(forKey: "Token") else {
            print("토큰이 없습니다.")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        print("토큰: \(token)")
        
        AF.request("\(url)/auth/check_token", method: .get, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("JSON Response: \(jsonString)")
                        }
                        let userIdResponse = try JSONDecoder().decode(UserIdResponse.self, from: data)
                        self.userId = userIdResponse.body.userId.payload
                        print("User ID fetched successfully: \(self.userId ?? 0)")
                        self.fetchUserData(userId: self.userId ?? 0)
                    } catch {
                        print("사용자 데이터 디코딩 실패: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                        print("응답 에러: \(jsonString)")
                    }
                    print("사용자 데이터 가져오기 실패: \(error.localizedDescription)")
                }
            }
    }
    
    func fetchUserData(userId: Int) {
        guard let token = KeychainWrapper.standard.string(forKey: "Token") else {
            print("토큰이 없습니다.")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let requestUrl = "\(url)/users/\(userId)"
        print("요청 URL: \(requestUrl)")
        
        AF.request(requestUrl, method: .get, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("JSON 반환값: \(jsonString)")
                        }
                        let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                        self.userData = userResponse.body
                        print("유저 데이터: \(userResponse.body)")
                    } catch {
                        print("디코딩 실패: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                        print("응답 안됨: \(jsonString)")
                    }
                    print("데이터 가져오기 실패: \(error.localizedDescription)")
                }
            }
    }
    
    func teacherCounselor(chatViewModel: ChatViewModel) {
        guard let userId = userId else {
            print("유저 아이디가 설정되지 않았습니다.")
            return
        }
        
        let chatRequest: [String: Any] = [
            "userId": [userId, 6]
        ]
        
        guard let token = KeychainWrapper.standard.string(forKey: "Token") else {
            print("토큰이 없습니다.")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        AF.request("\(url)/chats", method: .post, parameters: chatRequest, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("채팅방 생성 성공: \(jsonString)")
                        if let jsonData = jsonString.data(using: .utf8),
                           let responseDict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
                           let body = responseDict["body"] as? [String: Any],
                           let chatId = body["id"] as? Int {
                            chatViewModel.enterChat(chatId: chatId)
                        }
                    }
                case .failure(let error):
                    if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                        print("응답 에러: \(jsonString)")
                    }
                }
            }
    }

    func studentCounselor() {
        print("학생상담사와 상담하기")
    }
}
