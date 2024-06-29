import Foundation
import SwiftUI
import Alamofire
import SwiftKeychainWrapper

class ChatViewModel: ObservableObject {
    @Published var showColorPicker = false
    @Published var colors: [ColorOption] = [
        ColorOption(red: 255, green: 205, blue: 234),
        ColorOption(red: 249, green: 232, blue: 151),
        ColorOption(red: 210, green: 227, blue: 200),
        ColorOption(red: 57, green: 167, blue: 255),
        ColorOption(red: 181, green: 41, blue: 230)
    ]
    @Published var chatRooms: [ChatRoom] = []
    @Published var messages: [Message] = []
    @Published var userId: Int?

    private var url = "http://54.180.226.0:3000"
    private var socketManager = SocketIOManager.shared

    init() {
        socketManager.$receivedMessages.assign(to: &$messages)
    }

    func toggleColorPicker() {
        withAnimation {
            showColorPicker.toggle()
        }
    }

    func fetchUserIdAndChatRooms() {
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
                        self.userId = userIdResponse.body.userId.payload
                        print("User ID fetched successfully: \(self.userId ?? 0)")
                        self.fetchChatRooms(userId: self.userId ?? 0)
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

    func fetchChatRooms(userId: Int) {
        guard let token = KeychainWrapper.standard.string(forKey: "Token") else {
            print("토큰이 없습니다.")
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        let requestUrl = "\(url)/chats"
        print("요청 URL: \(requestUrl)")

        AF.request(requestUrl, method: .get, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("서버 응답: \(jsonString)")
                        }
                        let chatRoomsResponse = try JSONDecoder().decode([ChatRoom].self, from: data)
                        self.chatRooms = chatRoomsResponse
                        print("채팅방 목록: \(chatRoomsResponse)")
                    } catch {
                        print("디코딩 실패: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                        print("응답 에러: \(jsonString)")
                    }
                    print("채팅방 목록 가져오기 실패: \(error.localizedDescription)")
                }
            }
    }

    func fetchMessages(chatId: Int) {
        guard let token = KeychainWrapper.standard.string(forKey: "Token") else {
            print("토큰이 없습니다.")
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        let requestUrl = "\(url)/chats/messages/\(chatId)"
        print("요청 URL: \(requestUrl)")

        AF.request(requestUrl, method: .get, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let messagesResponse = try JSONDecoder().decode([Message].self, from: data)
                        self.messages = messagesResponse
                        print("메시지 목록: \(messagesResponse)")
                    } catch {
                        print("디코딩 실패: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                        print("응답 에러: \(jsonString)")
                    }
                    print("메시지 목록 가져오기 실패: \(error.localizedDescription)")
                }
            }
    }

    func enterChat(chatId: Int) {
        socketManager.enterChat(chatId: chatId)
    }

    func sendMessage(chatId: Int, message: String) {
        guard let authorId = userId else {
            print("유저 아이디가 설정되지 않았습니다.")
            return
        }

        let newMessage = Message(chatId: chatId, authorId: authorId, content: message)
        
        // Socket.IO 메시지 전송
        socketManager.sendMessage(chatId: chatId, authorId: authorId, message: message)
        
        // 메시지를 로컬에 추가
        messages.append(newMessage)
        print("Message added to local messages: \(newMessage)")
    }

    func postCommentAndDeleteChatRoom(chatId: Int, comment: String) {
        guard let userId = userId, let token = KeychainWrapper.standard.string(forKey: "Token") else {
            print("유저 아이디가 설정되지 않았습니다.")
            return
        }

        let feedbackData: [String: Any] = ["feedback": comment, "userId": userId]
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]

        // Post Comment
        print("Sending feedback: \(feedbackData) to \(url)/admin-comment")
        AF.request("\(url)/admin-comment", method: .post, parameters: feedbackData, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("코멘트 전송 성공: \(jsonString)")
                    }
                    // 코멘트 전송 후 채팅방 삭제
                    self.deleteChatRoom(chatId: chatId)
                case .failure(let error):
                    if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                        print("코멘트 응답 에러: \(jsonString)")
                    }
                    print("코멘트 전송 실패: \(error.localizedDescription)")
                }
            }
    }

    func deleteChatRoom(chatId: Int) {
        guard let token = KeychainWrapper.standard.string(forKey: "Token") else {
            print("토큰이 없습니다.")
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        let requestUrl = "\(url)/chats/\(chatId)"
        print("요청 URL: \(requestUrl)")

        AF.request(requestUrl, method: .delete, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success:
                    print("채팅방 삭제 성공: \(chatId)")
                    self.chatRooms.removeAll { $0.id == chatId }
                case .failure(let error):
                    if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                        print("응답 에러: \(jsonString)")
                    }
                    print("채팅방 삭제 실패: \(error.localizedDescription)")
                }
            }
    }
}

struct ChatRoom: Codable, Identifiable {
    let id: Int
}

class ThemeManager: ObservableObject {
    @Published var selectedColor: Color
        
    init() {
        self.selectedColor = Color(red: 210 / 255, green: 227 / 255, blue: 200 / 255)
    }
}
