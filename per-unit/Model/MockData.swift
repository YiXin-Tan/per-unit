//
//  MockData.swift
//  per-unit
//
//  Created by yixin on 19/09/2025.
//

struct MockData {
    static let sampleCategories: [Category] = [
        Category(name: "Toilet paper"),
        Category(name: "Shapoo"),
        Category(name: "Toothbrush"),
        Category(name: "Coconut milk"),
    ]
    
    static let sampleProduct: Product = Product(
        name: "Palmolive Shampoo Argan Oil",
        price: 3.58,
        amount: 380,
        unit: .ml
    )
    
    var sampleScan0 = ["Tr", "resemme Shampoo Smooth & Silky 900mL", "2111", "1117526", "$7.49", "50122", "5012254059388", "46jOM SOI", "TRESEMME SHIMP", "LION SUK", "28001087350860", "Tresemme", "21117521"]

    var sampleScan1 = ["• 8 - drive.google.com/drive/u/3/folders/1b9T_W4r8E8hzM7IM1qovoZDcASLtC1vk", "Palmolive Shower Gel Absolute Relax 750ml", "RelaxX61022009", "$6.28", "8850006536322", "Fig 1a, 1b, 1c: Price labels from Savemore", "displayed. Manual calculation is required fc"]

    var sampleScan2 = ["GC (AL) A / 015", "CO CO", "CRI AA", "400", "NET", "AYAM Coconut Cream", "400ml", "$ 420", "local asian grocer, similarly lacking un"]

    var sampleScan3 = ["AYAM Coconut Cream", "270m l", "$3.49"]

    var sampleScan4 = ["$ 599", "WILLOWTON FREE RANGE", "Free Range Fresh Whole Chicken", "per kg", "$5.99 per kg", "D 399578-KGM"]
}
