//
//  LoginScreen.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 1/25/25.
//

import SwiftUI

struct LoginScreen: View {
    @Environment(\.authenticationController) private var authenticationController

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var message: String = ""
    
    @AppStorage("userId") private var userId: Int?
    
    private var isFormValid: Bool {
        !username.isEmptyOrWhitespace && !password.isEmptyOrWhitespace
    }
    private func login() async {
        do {
            let response = try await authenticationController.login(username: username, password: password)
            guard let token = response.token,
                  let userId = response.userId, response.success else {
                message = response.message ?? "Request cannot be completed."
                return
            }
            print(token)
            Keychain.set(token, forKey: "jwttoken")
            self.userId = userId
        } catch {
            message = error.localizedDescription
        }
        username = ""
        password = ""
    }
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.2, blue: 0.4), // Dark blue
                    Color(red: 0.2, green: 0.4, blue: 0.6)  // Lighter blue
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            VStack(spacing: 30) {
                // Logo or App Name
                VStack(spacing: 8) {
                    Image(systemName: "ant.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                    Text("Star Pest Control")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(.top, 40)
                // Login Card
                VStack(spacing: 20) {
                    // Username Field
                    TextField("Username", text: $username)
                        .textInputAutocapitalization(.never)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.green.opacity(0.5), lineWidth: 1)
                        )
                        .autocorrectionDisabled()
                    // Password Field
                    SecureField("Password", text: $password)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.green.opacity(0.5), lineWidth: 1)
                        )
                    // Login Button
                    Button(action: {
                        Task {
                            await login()
                        }
                    }) {
                        Text("Login")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isFormValid ? Color.blue : Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(!isFormValid)
                    // Message
                    Text(message)
                        .foregroundColor(.red)
                        .font(.caption)
                        .frame(minHeight: 20)
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 30)
                Spacer()
                // Additional Options
                HStack(spacing: 20) {
                    Button("Forgot Password?") {
                        // Add forgot password action
                    }
                    .foregroundColor(.white.opacity(0.9))
                    
                    Button("Sign Up") {
                        // Add sign up action
                    }
                    .foregroundColor(.white.opacity(0.9))
                }
                .font(.footnote)
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginScreen()
    }.environment(\.authenticationController, .development)
}
