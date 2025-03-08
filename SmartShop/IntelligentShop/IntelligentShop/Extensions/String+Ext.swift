//
//  String+Ext.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 1/23/25.
//

import Foundation

extension String {
    var isEmptyOrWhitespace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    var isZipCode: Bool {
        // Adjust this regex for your ZIP code requirements (US format example here)
        let zipCodeRegex = "^[0-9]{5}(-[0-9]{4})?$"
        return NSPredicate(format: "SELF MATCHES %@", zipCodeRegex).evaluate(with: self)
    }
}
