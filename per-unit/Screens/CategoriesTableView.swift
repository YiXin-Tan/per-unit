//
//  CategoriesTableView.swift
//  per-unit
//
//  Created by yixin on 19/09/2025.
//

import SwiftUI

struct CategoriesTableView: View {
    
    @State private var categories: [Category] = MockData.sampleCategories

    var body: some View {
        List {
            // Header
            HStack {
                Text("Name").bold()
                Spacer()
                Text("Last Modified").bold()
            }

            // Content
            ForEach(categories) { category in
                HStack {
                    Text(category.name)
                    Spacer()
                    Text(category.lastModified, style: .date)
                }
            }
        }
    }
}


#Preview {
    CategoriesTableView()
}
