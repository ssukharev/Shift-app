//
//  Product.swift
//  Shift-app
//
//  Created by Suharev Sergey on 13.10.2025.
//

import Foundation

//Структура-модель продукта
struct Product: Identifiable, Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    
    //Цена
    var priceFormatted: String {
        return String(format: "$%.2f", price)
    }
}

