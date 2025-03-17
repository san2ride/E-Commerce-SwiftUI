//
//  PaymentController.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 3/13/25.
//

import Foundation
import Stripe
import StripePaymentSheet

struct PaymentController {
    let httpClient: HTTPClient
    
    @MainActor
    func preparePaymentSheet(for cart: Cart) async throws -> PaymentSheet {
        let body = ["totalAmount": cart.total]
        let bodyData = try JSONEncoder().encode(body)
        let resource = Resource(url: Constants.Urls.createPaymentIntent,
                                method: .post(bodyData),
                                modelType: CreatePaymentIntentResponse.self)
        let response = try await httpClient.load(resource)
        guard let customerId = response.customerId,
              let customerEphemeralKeySecret = response.customerEphemeralKeySecret,
              let paymentIntentClientSecret = response.paymentIntentClientSecret else {
            throw PaymentServiceError.missingPaymentDetails
        }
        STPAPIClient.shared.publishableKey = response.publishableKey
        // create payment sheet instance
        var configuaration = PaymentSheet.Configuration()
        configuaration.merchantDisplayName = "Star Pest Control"
        configuaration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
        
        return PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuaration)
    }
}
