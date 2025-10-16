//
//  MainViewModel.swift
//  Shift-app
//
//  Created by Suharev Sergey on 13.10.2025.
//

import Foundation

// MARK: - ViewModel главного экрана
/// Управляет загрузкой и отображением списка продуктов
@MainActor
final class MainViewModel: ObservableObject {
    // Состояние экрана
    @Published var products: [Product] = []          // Список продуктов
    @Published var isLoading: Bool = false           // Флаг загрузки
    @Published var errorMessage: String?             // Сообщение об ошибке
    @Published var showGreeting: Bool = false        // Показывать ли модальное окно приветствия
    
    private let networkService = NetworkService.shared
    private let userStorage = UserStorageService.shared
    
    /// Имя текущего пользователя из хранилища
    var userName: String {
        return userStorage.loadUser()?.firstName ?? "Гость"
    }
    
    /// Сообщение приветствия для пользователя
    var greetingMessage: String {
        return "Привет, \(userName)!"
    }
    
    // MARK: - Публичные методы
    
    /// Загружает список продуктов с сервера
    /// Обрабатывает ошибки и обновляет UI соответственно
    func fetchProducts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            products = try await networkService.fetchProducts()
            isLoading = false
        } catch let error as NetworkError {
            isLoading = false
            // Обрабатываем различные типы ошибок
            switch error {
            case .invalidURL:
                errorMessage = "Некорректный URL"
            case .noData:
                errorMessage = "Нет данных"
            case .decodingError:
                errorMessage = "Ошибка декодирования данных"
            case .serverError(let message):
                errorMessage = message
            }
        } catch {
            isLoading = false
            errorMessage = "Неизвестная ошибка: \(error.localizedDescription)"
        }
    }
    
    /// Переключает отображение модального окна приветствия
    func toggleGreeting() {
        showGreeting.toggle()
    }
}

