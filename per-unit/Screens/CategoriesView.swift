//
//  CategoriesView.swift
//  per-unit
//
//  Created by yixin on 19/09/2025.
//

import SwiftUI

struct CategoriesView: View {
    var body: some View {
        NavigationStack {
            VStack {
                // TODO: search and filter
                
                CategoriesTableView()
            }
            .navigationTitle("Categories")
        }
    }
}

#Preview {
    CategoriesView()
}
