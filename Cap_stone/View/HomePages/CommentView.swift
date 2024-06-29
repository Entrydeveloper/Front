// CommentView.swift

import SwiftUI

struct CommentView: View {
    @ObservedObject var viewModel: ChatViewModel
    var chatRoom: ChatRoom
    @State private var rating: Int = 0
    @State private var comment: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("상담 후기 작성")
                .font(.largeTitle)
                .bold()
                .padding()

            Text("상담 만족도")
                .font(.title2)
                .padding()

            HStack {
                ForEach(1..<6) { i in
                    Image(systemName: i <= rating ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(i <= rating ? .yellow : .gray)
                        .onTapGesture {
                            rating = i
                        }
                }
            }

            Text("상담이 어땠는지 작성해주세요")
                .font(.title2)
                .padding(.top)

            TextEditor(text: $comment)
                .frame(height: 200)
                .border(Color.gray, width: 1)
                .padding()

            Button(action: {
                // 댓글 전송 후 채팅방 삭제
                viewModel.postCommentAndDeleteChatRoom(chatId: chatRoom.id, comment: comment)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("후기 등록하기")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        let chatViewModel = ChatViewModel()
        let chatRoom = ChatRoom(id: 1) // 미리보기용 ChatRoom 객체
        CommentView(viewModel: chatViewModel, chatRoom: chatRoom)
    }
}
