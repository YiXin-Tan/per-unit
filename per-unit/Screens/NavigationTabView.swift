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
            Tab("Scan", systemImage: "document.viewfinder") {
                ScanView()
            }

            Tab("Categories", systemImage: "rectangle.stack") {
                CategoriesView()
            }
        }

    }
}

#Preview {
    NavigationTabView()
}
