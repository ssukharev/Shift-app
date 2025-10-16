//
//  RegistrationView.swift
//  Shift-app
//
//  Created by Suharev Sergey on 13.10.2025.
//

import SwiftUI

// MARK: - Экран регистрации
/// Форма для регистрации нового пользователя с валидацией полей
struct RegistrationView: View {
    @StateObject private var viewModel = RegistrationViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Заголовок
                    Text("Регистрация")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    
                    // Поле ввода имени
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Имя")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Введите имя", text: $viewModel.firstName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.words)
                            .onChange(of: viewModel.firstName) { _ in
                                viewModel.validateField(.firstName)
                            }
                        
                        if let error = viewModel.firstNameError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Поле ввода фамилии
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Фамилия")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Введите фамилию", text: $viewModel.lastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.words)
                            .onChange(of: viewModel.lastName) { _ in
                                viewModel.validateField(.lastName)
                            }
                        
                        if let error = viewModel.lastNameError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Поле выбора даты рождения
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Дата рождения")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        DatePicker(
                            "Выберите дату",
                            selection: $viewModel.birthDate,
                            in: ...Date(),
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.compact)
                        .onChange(of: viewModel.birthDate) { _ in
                            viewModel.validateField(.birthDate)
                        }
                        
                        if let error = viewModel.birthDateError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Поле ввода пароля
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Пароль")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        SecureField("Введите пароль", text: $viewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: viewModel.password) { _ in
                                viewModel.validateField(.password)
                            }
                        
                        if let error = viewModel.passwordError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        } else {
                            Text("Минимум 8 символов, заглавные буквы и цифры")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Поле подтверждения пароля
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Подтверждение пароля")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        SecureField("Повторите пароль", text: $viewModel.confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: viewModel.confirmPassword) { _ in
                                viewModel.validateField(.confirmPassword)
                            }
                        
                        if let error = viewModel.confirmPasswordError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Кнопка регистрации (активна только при валидных данных)
                    Button(action: {
                        viewModel.register()
                    }) {
                        Text("Регистрация")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isFormValid ? Color.blue : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(!viewModel.isFormValid)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $viewModel.isRegistrationSuccessful) {
            MainView()
        }
    }
}

#Preview {
    RegistrationView()
}

