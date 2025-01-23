//
//  RegistrationScreen.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 1/23/25.
//

import SwiftUI

struct RegistrationScreen: View {
    @Environment(\.authenticationController) private var authenticationController
    @Environment(\.dismiss) private var dismiss
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    private var isFormValid: Bool {
        !username.isEmptyOrWhitespace && !password.isEmptyOrWhitespace
    }
    
    var body: some View {
        Form {
            TextField("User Name", text: $username)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
            Button("Register") {
                
            }.disabled(isFormValid)
        }.navigationTitle("Register")
    }
}

#Preview {
    NavigationStack {
        RegistrationScreen()
    }.environment(\.authenticationController, .development)
}
