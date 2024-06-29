import Foundation
import Alamofire
import SwiftKeychainWrapper

class MyPageViewModel: ObservableObject {
    @Published var userData: UserResponse.UserBody?
    @Published var comments: [Comment] = []

    private var url = "http://54.180.226.0:3000"

    func fetchUserId() {
        guard let token = KeychainWrapper.standard.string(forKey: "Token") else {
            print("토큰이 없습니다.")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        AF.request("\(url)/auth/check_token", method: .get, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let userIdResponse = try JSONDecoder().decode(UserIdResponse.self, from: data)
                        let userId = userIdResponse.body.userId.payload
                        self.fetchUserData(userId: userId)
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
                        let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                        self.userData = userResponse.body
                        self.fetchComments(userId: userId)
                    } catch {
                        print("유저 데이터 디코딩 실패: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                        print("응답 에러: \(jsonString)")
                    }
                    print("유저 데이터 가져오기 실패: \(error.localizedDescription)")
                }
            }
    }

    func fetchComments(userId: Int) {
        guard let token = KeychainWrapper.standard.string(forKey: "Token") else {
            print("토큰이 없습니다.")
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        let requestUrl = "\(url)/admin-comment"
        print("요청 URL: \(requestUrl)")

        AF.request(requestUrl, method: .get, headers: headers)
            .validate()
            .responseData { response in
                print("요청 보냄: \(requestUrl)")
                print("요청 헤더: \(headers)")
                switch response.result {
                case .success(let data):
                    do {
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("응답 데이터: \(jsonString)")
                        }
                        let commentsResponse = try JSONDecoder().decode([Comment].self, from: data)
                        self.comments = commentsResponse
                        print("후기 목록: \(commentsResponse)")
                    } catch {
                        print("디코딩 실패: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                        print("응답 에러: \(jsonString)")
                    }
                    print("후기 목록 가져오기 실패: \(error.localizedDescription)")
                }
            }
    }

    func logout() {
        KeychainWrapper.standard.removeObject(forKey: "Token")
    }
}

struct Comment: Codable, Identifiable {
    let id: Int
    let feedback: String
    let userId: Int
}
