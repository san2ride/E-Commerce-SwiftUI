//
//  EnvironmentValues+Ext.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 3/18/25.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    @Entry var paymentController = PaymentController(httpClient: HTTPClient())
    @Entry var uploaderDownloader = UploaderDownloader(httpClient: HTTPClient())
    @Entry var authenticationController = AuthenticationController(httpClient: HTTPClient())
}
