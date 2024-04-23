//
//  Components.swift
//  Cap_stone
//
//  Created by 박성민 on 4/3/24.
//

import SwiftUI

struct CustomTextFeild: View{
    @Binding var text: String
    var placeholder: String
    
    init(_ text: Binding<String>, _ placeholder: String){
        self._text = text
        self.placeholder = placeholder
    }
    
    var body: some View{
        TextField(placeholder, text: $text)
            .padding(.leading, 50)
            .autocapitalization(.none) // 첫글자 자동 대문자 해제
            .disableAutocorrection(false) // 자동 수정 해제
    }
}

struct DividerView: View {
    var body: some View {
        Divider()
            .frame(width: 300)
            .padding(.bottom, 40)
    }
}

struct CustomSecureField: View {
    @Binding var text: String
    var placeholder: String
    
    init(_ text: Binding<String>,_ placeholder: String) {
        self._text = text
        self.placeholder = placeholder
    }
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .padding(.leading, 50)
            .autocapitalization(.none)
            .disableAutocorrection(false)
    }
}

struct CustomButton: View{
    var title: String
    
    init(_ title: String){
        self.title = title
    }
    var body: some View{
        Text(title)
            .foregroundStyle(Color.black)
            .font(.system(size:23))
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            .padding(EdgeInsets(top: 15, leading: 120, bottom: 15, trailing: 120))
            .background(Color(red: 210 / 255, green: 227 / 255, blue: 200 / 255))
            .cornerRadius(10)
    }
}
