//
//  CategoryAddAlert.swift
//  per-unit
//
//  Created by yixin on 10/10/2025.
//

import SwiftUI

struct CategoryAddAlertButton: View {
    @Environment(\.managedObjectContext) var moc
    @State var showingAlert = false
    @State var categoryName = ""
    var body: some View {
        Button("Create New Category", systemImage: "folder.badge.plus"){
            showingAlert.toggle()
        }
        .alert("Create new category", isPresented: $showingAlert){
            TextField("Category name", text: $categoryName)
            Button("Cancel", role: .cancel, action: {})
            Button("OK", action: { Category.createNewCategory(name: categoryName, context: moc)})
        } message: {
            Text("Enter a new category name")
        }
    }
}

#Preview {
    CategoryAddAlertButton()
}

// REFERENCES
// https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-a-textfield-to-an-alert
