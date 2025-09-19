//
//  Category.swift
//  per-unit
//
//  Created by yixin on 19/09/2025.
//

import Foundation

struct Category: Identifiable {
    var id = UUID()
    var name: String
    var lastModified = Date() // capture timestamp when initialised
    // TODO var reference to nested products?
}

