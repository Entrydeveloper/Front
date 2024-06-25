import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showImagePicker = false
    @ObservedObject var imageData = ImageData()
    
    var body: some View {
        VStack {
            MainViewTitle("위클 행사 정보")
            if let selectedImage = imageData.selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .frame(width: 290, height: 250)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 290, height: 250)
            }
            if let userdata = viewModel.userData {
                if userdata.username == "admin" {
                    Button {
                        showImagePicker = true
                    } label: {
                        Text("사진 변경하기")
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(selectedImage: $imageData.selectedImage)
                    }
                    HStack{
                        MainViewTitle("실시간")
                            .padding(.leading,50)
                        Spacer()
                    }
                    HStack{
                        Text("또상 랭킹")
                            .font(.system(size: 25))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding(.leading,50)
                        Spacer()
                    }
                    HStack{
                        VStack{
                            Image("user_profil")
                                .resizable()
                                .frame(width: 70,height: 70)
                                .padding(.top,20)
                            Text("이승보")
                                .font(.system(size: 22))
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(white: 0.99))
                                    .frame(width: 90, height: 80)
                                    .shadow(radius: 5)
                                Text("2")
                                    .font(.system(size: 36))
                                    .foregroundColor(.green)
                                    .padding(.bottom,20)
                            }
                            .padding(.top, 10)
                        }
                        VStack{
                            Image("user_profil")
                                .resizable()
                                .frame(width: 70,height: 70)
                            Text("권가령")
                                .font(.system(size: 22))
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(white: 0.99))
                                    .frame(width: 90, height: 100)
                                    .shadow(radius: 5)
                                Text("1")
                                    .font(.system(size: 36))
                                    .foregroundColor(.green)
                                    .padding(.bottom,40)
                            }
                            .padding(.top, 10)
                        }
                        .padding()
                        VStack{
                            Image("user_profil")
                                .resizable()
                                .frame(width: 70,height: 70)
                                .padding(.top,40)
                            Text("성홍제")
                                .font(.system(size: 22))
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(white: 0.99))
                                    .frame(width: 90, height: 60)
                                    .shadow(radius: 5)
                                Text("3")
                                    .font(.system(size: 36))
                                    .foregroundColor(.green)
                                    
                                }
                            .padding(.top, 10)
                        }
                    }
                    
                } else {
                    MainViewTitle("익명 상담하기")
                    CounselingButton("또래상담사와", "채팅하기") {
                        viewModel.teacherCounselor()
                    }
                    CounselingButton("위클쌤과", "상담하기") {
                        viewModel.studentCounselor()
                    }
                }
            } else {
                Text("잠시만 기다려주세요")
            }
            Spacer()
        }
        .onAppear {
            viewModel.fetchUserId()
        }
    }
}

#Preview {
    MainView()
        .environmentObject(ThemeManager())
}
