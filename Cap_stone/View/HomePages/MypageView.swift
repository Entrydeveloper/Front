import SwiftUI

struct MypageView: View {
    @StateObject private var viewModel = MyPageViewModel()
    @State private var isLoggedOut = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("user_profil")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding()
                if let userData = viewModel.userData {
                    Text(userData.username)
                        .font(.system(size: 23))
                        .padding()
                    if userData.username == "admin" {
                        Divider()
                        Text("상담 후기")
                            .font(.system(size: 25))
                            .fontWeight(.bold)
                            .padding()
                        ScrollView {
                            VStack {
                                ForEach(viewModel.comments) { comment in
                                    VStack(alignment: .center, spacing: 8) {
                                        Text(comment.feedback)
                                            .font(.body)
                                            .multilineTextAlignment(.center)
                                            .padding(.bottom, 8)
                                    }
                                    .padding()
                                    .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .center)
                                    .background(Color(red: 236/255, green: 250/255, blue: 224/255))
                                    .cornerRadius(12)
                                    .shadow(color: .gray, radius: 1, x: 0, y: 1)
                                    .padding(.bottom, 8)
                                }
                            }
                            .padding()
                        }
                    }
                } else {
                    Text("잠시만 기다려 주세요")
                }
                Spacer()
                NavigationLink(destination: LoginView(), isActive: $isLoggedOut) {
                    Button {
                        viewModel.logout()
                        isLoggedOut = true
                    } label: {
                        Text("로그아웃")
                            .foregroundStyle(.red)
                            .padding(.bottom, 60)
                    }
                }
            }
            .onAppear {
                viewModel.fetchUserId()
            }
        }
    }
}

#Preview {
    MypageView()
        .environmentObject(ThemeManager())
}
