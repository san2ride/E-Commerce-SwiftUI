//
//  ProfileScreen.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 1/28/25.
//

import SwiftUI

struct ProfileScreen: View {
    @AppStorage("userId") private var userId: String?
    @Environment(CartStore.self) private var cartStore
    @Environment(UserStore.self) private var userStore
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var street: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var zipCode: String = ""
    @State private var country: String = ""
    
    @State private var validationErrors: [String] = []
    @State private var updatingUserInfo: Bool = false
    
    private var isFormValid: Bool {
        !firstName.isEmptyOrWhitespace &&
        !lastName.isEmptyOrWhitespace &&
        !street.isEmptyOrWhitespace &&
        !city.isEmptyOrWhitespace &&
        !state.isEmptyOrWhitespace &&
        !zipCode.isEmptyOrWhitespace &&
        !country.isEmptyOrWhitespace
    }
    
    private func validateForm() -> Bool {
        validationErrors = []
        
        if firstName.isEmptyOrWhitespace {
            validationErrors.append("First name is required.")
        }
        if lastName.isEmptyOrWhitespace {
            validationErrors.append("Last name is required.")
        }
        if street.isEmptyOrWhitespace {
            validationErrors.append("Street is required.")
        }
        if city.isEmptyOrWhitespace {
            validationErrors.append("City is required.")
        }
        if state.isEmptyOrWhitespace {
            validationErrors.append("State is required.")
        }
        if !zipCode.isZipCode {
            validationErrors.append("Invalid ZIP code.")
        }
        if country.isEmptyOrWhitespace {
            validationErrors.append("Country is required.")
        }
        return validationErrors.isEmpty
    }
    private func updateUserInfo() async {
        do {
            let userInfo = UserInfo(firstName: firstName,
                                    lastName: lastName,
                                    street: street,
                                    city: city,
                                    state: state,
                                    zipCode: zipCode,
                                    country: country)
            try await userStore.updateUserInfo(userInfo: userInfo)
        } catch {
            print(error.localizedDescription)
        }
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
            VStack(spacing: 20) {
                // Header
                Text("Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                // Profile Card
                ScrollView {
                    VStack(spacing: 20) {
                        // Personal Information Section
                        VStack(spacing: 15) {
                            Text("Personal Information")
                                .font(.headline)
                                .foregroundColor(.white)
                            TextField("First Name", text: $firstName)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding()
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                                )
                            TextField("Last Name", text: $lastName)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding()
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                                )
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                        // Address Section
                        VStack(spacing: 15) {
                            Text("Address")
                                .font(.headline)
                                .foregroundColor(.white)
                            TextField("Street", text: $street)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding()
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                                )
                            TextField("City", text: $city)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding()
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                                )
                            TextField("State", text: $state)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding()
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                                )
                            TextField("Zip Code", text: $zipCode)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding()
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                                )
                            TextField("Country", text: $country)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding()
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                                )
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                        
                        // Validation Errors
                        if !validationErrors.isEmpty {
                            VStack(spacing: 5) {
                                ForEach(validationErrors, id: \.self) { error in
                                    Text(error)
                                        .foregroundColor(.red)
                                        .font(.caption)
                                }
                            }
                            .padding()
                        }
                        // Buttons
                        VStack(spacing: 15) {
                            Button(action: {
                                if validateForm() {
                                    updatingUserInfo = true
                                }
                            }) {
                                Text("Save Profile")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(isFormValid ? Color.blue : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .disabled(!isFormValid)
                            Button(action: {
                                let _ = Keychain<String>.delete("jwttoken")
                                userId = nil
                                cartStore.emptyCart()
                            }) {
                                Text("Sign Out")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
                }
            }
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        }
        .onChange(of: userStore.userInfo, initial: true, {
            if let userInfo = userStore.userInfo {
                firstName = userInfo.firstName ?? ""
                lastName = userInfo.lastName ?? ""
                street = userInfo.street ?? ""
                city = userInfo.city ?? ""
                state = userInfo.state ?? ""
                zipCode = userInfo.zipCode ?? ""
                country = userInfo.country ?? ""
            }
        })
        .navigationBarHidden(true)
        .task(id: updatingUserInfo) {
            if updatingUserInfo {
                await updateUserInfo()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileScreen()
            .environment(CartStore(httpClient: .development))
            .environment(UserStore(httpClient: .development))
    }
}
