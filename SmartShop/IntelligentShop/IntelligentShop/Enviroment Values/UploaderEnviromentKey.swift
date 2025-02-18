//
//  UploaderEnviromentKey.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 2/11/25.
//

import Foundation
import SwiftUI

private struct UploaderEnviromentKey: EnvironmentKey {
    static let defaultValue = Uploader(httpClient: HTTPClient())
}

extension EnvironmentValues {
    var uploader: Uploader {
        get { self[UploaderEnviromentKey.self] }
        set { self[UploaderEnviromentKey.self] = newValue }
    }
}
