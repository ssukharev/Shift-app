//
//  MainView.swift
//  Shift-app
//
//  Created by Suharev Sergey on 13.10.2025.
//

import SwiftUI

// MARK: - Главный экран
/// Отображает список продуктов и кнопку приветствия пользователя
struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Основной контент
                VStack {
                    // Индикатор загрузки
                    if viewModel.isLoading {
                        ProgressView("Загрузка продуктов...")
                            .padding()
                    // Экран ошибки
                    } else if let error = viewModel.errorMessage {
                        VStack(spacing: 20) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 60))
                                .foregroundColor(.red)
                            
                            Text("Ошибка")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text(error)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                            
                            Button(action: {
                                Task {
                                    await viewModel.fetchProducts()
                                }
                            }) {
                                Text("Повторить")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
                    // Пустой список
                    } else if viewModel.products.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "cart")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            
                            Text("Нет продуктов")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("Нажмите кнопку ниже, чтобы загрузить продукты")
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                        }
                    // Список продуктов
                    } else {
                        List(viewModel.products) { product in
                            ProductRowView(product: product)
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                .navigationTitle("Главный экран")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewModel.toggleGreeting()
                        }) {
                            Text("Приветствие")
                                .font(.headline)
                        }
                    }
                }
                .task {
                    await viewModel.fetchProducts()
                }
                .sheet(isPresented: $viewModel.showGreeting) {
                    GreetingView(message: viewModel.greetingMessage)
                }
            }
        }
    }
}

// MARK: - Ячейка продукта
/// Отображает информацию о продукте в списке
struct ProductRowView: View {
    let product: Product
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            // Изображение продукта
            AsyncImage(url: URL(string: product.image)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 80, height: 80)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            
            // Информация о продукте
            VStack(alignment: .leading, spacing: 8) {
                Text(product.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(product.category)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .textCase(.uppercase)
                
                Text(product.priceFormatted)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Модальное окно приветствия
/// Отображает приветственное сообщение для пользователя
struct GreetingView: View {
    let message: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "hand.wave.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.yellow)
                
                Text(message)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("Добро пожаловать в приложение!")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Закрыть")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MainView()
}

