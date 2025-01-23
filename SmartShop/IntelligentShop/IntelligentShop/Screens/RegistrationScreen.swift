//
//  RegistrationScreen.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 1/23/25.
//

import SwiftUI

struct RegistrationScreen: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    private var isFormValid: Bool {
        !username.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        Form {
            TextField("User Name", text: $username)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
            Button("Register") {
                
            }.disabled(true)
        }.navigationTitle("Register")
    }
}

#Preview {
    NavigationStack {
        RegistrationScreen()
    }
}
