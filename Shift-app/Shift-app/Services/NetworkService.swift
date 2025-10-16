//
//  NetworkService.swift
//  Shift-app
//
//  Created by Suharev Sergey on 13.10.2025.
//

import Foundation

// MARK: - Типы ошибок сети
enum NetworkError: Error {
    case invalidURL           // Некорректный URL
    case noData              // Нет данных
    case decodingError       // Ошибка декодирования JSON
    case serverError(String) // Ошибка сервера
}

// MARK: - Сервис для работы с сетью
/// Отвечает за все сетевые запросы в приложении
final class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    /// Загружает список продуктов с FakeStore API
    /// - Returns: Массив продуктов
    /// - Throws: NetworkError в случае ошибки
    func fetchProducts() async throws -> [Product] {
        // Проверяем валидность URL
        guard let url = URL(string: "https://fakestoreapi.com/products") else {
            throw NetworkError.invalidURL
        }
        
        // Выполняем запрос
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Проверяем статус код ответа
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError("Server returned error")
        }
        
        // Декодируем JSON в массив продуктов
        do {
            let products = try JSONDecoder().decode([Product].self, from: data)
            return products
        } catch {
            throw NetworkError.decodingError
        }
    }
}

