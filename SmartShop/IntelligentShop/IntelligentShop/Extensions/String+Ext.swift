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
}
