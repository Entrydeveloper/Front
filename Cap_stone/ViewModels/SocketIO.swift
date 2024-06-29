import Foundation
import SocketIO

class SocketIOManager: ObservableObject {
    static let shared = SocketIOManager()
    private var manager: SocketManager
    private var socket: SocketIOClient

    @Published var receivedMessages: [Message] = []

    private init() {
        self.manager = SocketManager(socketURL: URL(string: "ws://54.180.226.0:3000")!, config: [.log(true), .compress])
        self.socket = manager.defaultSocket
        
        socket = self.manager.socket(forNamespace: "/chats")
        addHandlers()
        socket.connect()
    }

    private func addHandlers() {
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket connected")
        }

        socket.on(clientEvent: .disconnect) { data, ack in
            print("Socket disconnected")
        }

        socket.on("receive_message") { [weak self] data, ack in
            if let messageData = data[0] as? [String: Any],
               let chatId = messageData["chatId"] as? Int,
               let authorId = messageData["authorId"] as? Int,
               let content = messageData["message"] as? String {
                let message = Message(chatId: chatId, authorId: authorId, content: content)
                DispatchQueue.main.async {
                    self?.receivedMessages.append(message)
                }
            }
        }
    }

    func enterChat(chatId: Int) {
        socket.emit("enter_chat", ["chatId": [chatId]])
        print("Entered chat with chatId: \(chatId)")
    }

    func sendMessage(chatId: Int, authorId: Int, message: String) {
        let messageData: [String: Any] = ["chatId": chatId, "authorId": authorId, "message": message]
        socket.emit("send_message", messageData)
        print("Message data sent: \(messageData)")
    }
}
