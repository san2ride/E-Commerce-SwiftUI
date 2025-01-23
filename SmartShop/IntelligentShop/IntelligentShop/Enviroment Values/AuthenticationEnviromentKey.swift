//
//  AuthenticationEnviromentKey.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 1/22/25.
//

import Foundation
import SwiftUI

private struct AuthenticationEnviromentKey: EnvironmentKey {
    static let defaultValue = AuthenticationController(httpClient: HTTPClient())
}
