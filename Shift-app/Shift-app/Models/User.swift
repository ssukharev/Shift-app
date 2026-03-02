//
//  User.swift
//  Shift-app
//
//  Created by Suharev Sergey on 13.10.2025.
//

import Foundation

//Структура для пользователя
struct User: Codable {
    let firstName: String
    let lastName: String
    let birthDate: Date
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

