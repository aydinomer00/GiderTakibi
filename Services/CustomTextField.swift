//
//  CustomTextField.swift
//  GiderTakibi
//
//  Created by Omer Murat Aydin on 21.10.2024.
//

import SwiftUI

// The CustomTextField provides a customized text field.
struct CustomTextField: View {
    var iconName: String
    var placeholder: String
    @Binding var text: String
    
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(Color.earthAccent)
            if isSecure {
                SecureField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            } else {
                TextField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

// Preview provider allows previewing the CustomTextField.
struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(iconName: "envelope.fill", placeholder: "Email", text: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}
