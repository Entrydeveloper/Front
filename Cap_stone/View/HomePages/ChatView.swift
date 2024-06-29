import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var userViewModel = MyPageViewModel()

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("채팅")
                        .padding([.top, .leading], 40)
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.selectedColor)
                    Spacer()
                    Button(action: {
                        viewModel.toggleColorPicker()
                    }) {
                        Image(systemName: "paintbrush.fill")
                            .padding([.top, .trailing], 40)
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                    }
                }

                List(viewModel.chatRooms) { chatRoom in
                    NavigationLink(destination: ChatRoomView(viewModel: viewModel, chatRoom: chatRoom)) {
                        HStack {
                            Image("user_profil")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .padding(.trailing, 8)

                            VStack(alignment: .leading) {
                                Text(userViewModel.userData?.username == "admin" ? "익명의 학생" : "선생님")
                                    .font(.headline)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                }
                .onAppear {
                    viewModel.fetchUserIdAndChatRooms()
                    userViewModel.fetchUserId()
                }

                Spacer()
            }
            .navigationBarHidden(true)
            .background(
                Group {
                    if viewModel.showColorPicker {
                        ColorPickerView(viewModel: viewModel)
                            .padding(.trailing, 25)
                            .offset(y: 80)
                            .transition(.opacity.combined(with: .scale))
                            .animation(.easeInOut, value: viewModel.showColorPicker)
                    }
                }
            )
        }
    }
}

struct ChatRoomView: View {
    @ObservedObject var viewModel: ChatViewModel
    var chatRoom: ChatRoom
    @State private var message: String = ""
    @State private var showCommentView = false

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(viewModel.messages.filter { $0.chatId == chatRoom.id }) { message in
                        HStack {
                            if message.authorId == viewModel.userId {
                                Spacer()
                                Text(message.content)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            } else {
                                Text(message.content)
                                    .padding()
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                    }
                }
            }

            HStack {
                TextField("Enter message", text: $message)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    viewModel.sendMessage(chatId: chatRoom.id, message: message)
                    message = ""
                }) {
                    Text("Send")
                }
                .padding()
            }

            Button(action: {
                showCommentView.toggle()
            }) {
                Text("상담 그만하기")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            viewModel.enterChat(chatId: chatRoom.id)
            viewModel.fetchMessages(chatId: chatRoom.id)
        }
        .sheet(isPresented: $showCommentView) {
            CommentView(viewModel: viewModel, chatRoom: chatRoom)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .environmentObject(ThemeManager())
    }
}
