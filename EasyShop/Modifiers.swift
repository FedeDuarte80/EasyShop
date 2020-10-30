//
//  Modifiers.swift
//  EasyShop
//
//  Created by Fede Duarte on 29/10/2020.
//

import SwiftUI

struct Modifiers: View {
    var body: some View {
        VStack {
            HStack {
                Text("Hello, World!").modifier(cellText())
            }.modifier(cellStack())
            
            HStack {
                Text("Carrefour")
                    .font(Font.system(size: 30))
                    .padding(.leading, 20)
                Spacer()
            }
            .frame(width: .infinity, height: 80)
            .background(Color("rowcolor"))
            .cornerRadius(20)
        }
    }
}

struct Modifiers_Previews: PreviewProvider {
    static var previews: some View {
        Modifiers()
    }
}

// MARK: - TextField

struct customTextfield: ViewModifier { // Image
    func body(content: Content) -> some View {
        content
            .padding(.top, 10)
            .padding(.leading, 15)
            .font(Font.system(size: 20))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .disableAutocorrection(true)
    }
}

struct cellText: ViewModifier { // Text
    func body(content: Content) -> some View {
        content
            .font(Font.system(size: 22))
            .foregroundColor(Color.black)
            .padding(.all, 5)
    }
}

struct cellStack: ViewModifier { // Stack
    func body(content: Content) -> some View {
        content
            .background(RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color("rowcolor"))) // card
    }
}
