//
//  UserStorageService.swift
//  Shift-app
//
//  Created by Suharev Sergey on 13.10.2025.
//

import Foundation

// MARK: - Сервис для работы с хранилищем пользователя
/// Отвечает за сохранение и загрузку данных пользователя из UserDefaults
final class UserStorageService {
    static let shared = UserStorageService()
    
    private let userKey = "currentUser"  // Ключ для хранения в UserDefaults
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    /// Сохраняет данные пользователя в UserDefaults
    func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            defaults.set(encoded, forKey: userKey)
        }
    }
    
    /// Загружает данные пользователя из UserDefaults
    /// - Returns: Объект User или nil, если данных нет
    func loadUser() -> User? {
        guard let data = defaults.data(forKey: userKey),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }
    
    /// Проверяет, зарегистрирован ли пользователь
    func isUserRegistered() -> Bool {
        return loadUser() != nil
    }
    
    /// Удаляет данные пользователя из хранилища
    func clearUser() {
        defaults.removeObject(forKey: userKey)
    }
}

