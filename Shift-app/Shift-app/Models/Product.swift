//
//  Product.swift
//  Shift-app
//
//  Created by Suharev Sergey on 13.10.2025.
//

import Foundation

// MARK: - Модель продукта
/// Структура для хранения информации о продукте из API
struct Product: Identifiable, Codable {
    let id: Int                // Уникальный идентификатор
    let title: String          // Название продукта
    let price: Double          // Цена
    let description: String    // Описание
    let category: String       // Категория товара
    let image: String          // URL изображения
    
    /// Форматированная цена в долларах
    var priceFormatted: String {
        return String(format: "$%.2f", price)
    }
}

