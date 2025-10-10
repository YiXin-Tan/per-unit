//
//  NavigationTabView.swift
//  per-unit
//
//  Created by yixin on 19/09/2025.
//

import SwiftUI

struct NavigationTabView: View {
    var body: some View {
        TabView {
            Tab("Products", systemImage: "cart") {
                ProductsView()
            }

            Tab("Categories", systemImage: "rectangle.stack") {
                CategoriesView()
            }
            
            Tab("Scan", systemImage: "document.viewfinder") {
                ScanView()
            }
            
            Tab("Test", systemImage: "hammer") {
                TestProductCategoryView()
            }
            
            Tab("Info", systemImage: "gear") {
                InfoView()
            }
        }

    }
}

#Preview {
    NavigationTabView()
}
