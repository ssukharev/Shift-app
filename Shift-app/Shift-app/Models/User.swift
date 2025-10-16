//
//  User.swift
//  Shift-app
//
//  Created by Suharev Sergey on 13.10.2025.
//

import Foundation

// MARK: - Модель пользователя
/// Структура для хранения данных зарегистрированного пользователя
struct User: Codable {
    let firstName: String    // Имя
    let lastName: String     // Фамилия
    let birthDate: Date      // Дата рождения
    
    /// Полное имя пользователя (имя + фамилия)
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

