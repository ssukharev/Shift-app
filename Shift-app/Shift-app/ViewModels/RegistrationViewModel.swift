//
//  RegistrationViewModel.swift
//  Shift-app
//
//  Created by Suharev Sergey on 13.10.2025.
//

import Foundation
import Combine

// MARK: - ViewModel для экрана регистрации
/// Управляет состоянием формы регистрации и валидацией полей
final class RegistrationViewModel: ObservableObject {
    // Поля ввода
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var birthDate: Date = Date()
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    // Сообщения об ошибках для каждого поля
    @Published var firstNameError: String?
    @Published var lastNameError: String?
    @Published var birthDateError: String?
    @Published var passwordError: String?
    @Published var confirmPasswordError: String?
    
    // Флаг успешной регистрации
    @Published var isRegistrationSuccessful: Bool = false
    
    private let userStorage = UserStorageService.shared
    
    // MARK: - Методы валидации (с установкой ошибок)
    
    /// Валидирует имя и устанавливает сообщение об ошибке при необходимости
    private func validateFirstName() -> Bool {
        firstNameError = nil
        
        if firstName.isEmpty {
            firstNameError = "Имя не может быть пустым"
            return false
        }
        
        if firstName.count < 2 {
            firstNameError = "Имя должно содержать минимум 2 символа"
            return false
        }
        
        if !firstName.allSatisfy({ $0.isLetter || $0.isWhitespace }) {
            firstNameError = "Имя может содержать только буквы"
            return false
        }
        
        return true
    }
    
    /// Валидирует фамилию и устанавливает сообщение об ошибке при необходимости
    private func validateLastName() -> Bool {
        lastNameError = nil
        
        if lastName.isEmpty {
            lastNameError = "Фамилия не может быть пустой"
            return false
        }
        
        if lastName.count < 2 {
            lastNameError = "Фамилия должна содержать минимум 2 символа"
            return false
        }
        
        if !lastName.allSatisfy({ $0.isLetter || $0.isWhitespace }) {
            lastNameError = "Фамилия может содержать только буквы"
            return false
        }
        
        return true
    }
    
    /// Валидирует дату рождения (возраст от 18 до 120 лет)
    private func validateBirthDate() -> Bool {
        birthDateError = nil
        
        let calendar = Calendar.current
        let now = Date()
        
        if birthDate > now {
            birthDateError = "Дата рождения не может быть в будущем"
            return false
        }
        
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        guard let age = ageComponents.year else {
            birthDateError = "Некорректная дата рождения"
            return false
        }
        
        if age < 18 {
            birthDateError = "Вам должно быть минимум 18 лет"
            return false
        }
        
        if age > 120 {
            birthDateError = "Некорректная дата рождения"
            return false
        }
        
        return true
    }
    
    /// Валидирует пароль (минимум 8 символов, заглавные, строчные буквы и цифры)
    private func validatePassword() -> Bool {
        passwordError = nil
        
        if password.isEmpty {
            passwordError = "Пароль не может быть пустым"
            return false
        }
        
        if password.count < 8 {
            passwordError = "Пароль должен содержать минимум 8 символов"
            return false
        }
        
        let hasUpperCase = password.contains(where: { $0.isUppercase })
        let hasLowerCase = password.contains(where: { $0.isLowercase })
        let hasDigit = password.contains(where: { $0.isNumber })
        
        if !hasUpperCase {
            passwordError = "Пароль должен содержать заглавные буквы"
            return false
        }
        
        if !hasLowerCase {
            passwordError = "Пароль должен содержать строчные буквы"
            return false
        }
        
        if !hasDigit {
            passwordError = "Пароль должен содержать цифры"
            return false
        }
        
        return true
    }
    
    /// Валидирует подтверждение пароля (должно совпадать с основным паролем)
    private func validateConfirmPassword() -> Bool {
        confirmPasswordError = nil
        
        if confirmPassword.isEmpty {
            confirmPasswordError = "Подтвердите пароль"
            return false
        }
        
        if password != confirmPassword {
            confirmPasswordError = "Пароли не совпадают"
            return false
        }
        
        return true
    }
    
    // MARK: - Публичные методы
    
    /// Проверяет валидность всей формы
    /// Используется для активации/деактивации кнопки регистрации
    var isFormValid: Bool {
        return isFirstNameValid &&
               isLastNameValid &&
               isBirthDateValid &&
               isPasswordValid &&
               isConfirmPasswordValid
    }
    
    // MARK: - Проверки валидности (без побочных эффектов)
    // Эти методы только проверяют данные, не изменяя состояние
    // Используются для isFormValid, чтобы избежать изменений состояния во время рендеринга
    
    private var isFirstNameValid: Bool {
        return !firstName.isEmpty &&
               firstName.count >= 2 &&
               firstName.allSatisfy({ $0.isLetter || $0.isWhitespace })
    }
    
    private var isLastNameValid: Bool {
        return !lastName.isEmpty &&
               lastName.count >= 2 &&
               lastName.allSatisfy({ $0.isLetter || $0.isWhitespace })
    }
    
    private var isBirthDateValid: Bool {
        let calendar = Calendar.current
        let now = Date()
        
        guard birthDate <= now else { return false }
        
        guard let age = calendar.dateComponents([.year], from: birthDate, to: now).year else {
            return false
        }
        
        return age >= 18 && age <= 120
    }
    
    private var isPasswordValid: Bool {
        return password.count >= 8 &&
               password.contains(where: { $0.isUppercase }) &&
               password.contains(where: { $0.isLowercase }) &&
               password.contains(where: { $0.isNumber })
    }
    
    private var isConfirmPasswordValid: Bool {
        return !confirmPassword.isEmpty &&
               password == confirmPassword
    }
    
    /// Выполняет регистрацию пользователя
    /// Сохраняет данные в UserDefaults и устанавливает флаг успешной регистрации
    func register() {
        guard isFormValid else { return }
        
        let user = User(
            firstName: firstName,
            lastName: lastName,
            birthDate: birthDate
        )
        
        userStorage.saveUser(user)
        isRegistrationSuccessful = true
    }
    
    /// Валидирует конкретное поле и устанавливает сообщение об ошибке
    /// Вызывается при изменении значения поля (onChange)
    func validateField(_ field: RegistrationField) {
        switch field {
        case .firstName:
            _ = validateFirstName()
        case .lastName:
            _ = validateLastName()
        case .birthDate:
            _ = validateBirthDate()
        case .password:
            _ = validatePassword()
        case .confirmPassword:
            _ = validateConfirmPassword()
        }
    }
}

// MARK: - Типы полей регистрации
enum RegistrationField {
    case firstName
    case lastName
    case birthDate
    case password
    case confirmPassword
}

