//
//  PaymentControllerEnviromentKey.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 3/17/25.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    @Entry var paymentController = PaymentController(httpClient: HTTPClient())
}
