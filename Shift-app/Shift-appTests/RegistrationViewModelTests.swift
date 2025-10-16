//
//  RegistrationViewModelTests.swift
//  Shift-appTests
//
//  Created by Suharev Sergey on 15.10.2025.
//

import XCTest
@testable import Shift_app

final class RegistrationViewModelTests: XCTestCase {
    var viewModel: RegistrationViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = RegistrationViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        UserStorageService.shared.clearUser()
        super.tearDown()
    }
    
    // MARK: - First Name Tests
    
    func testFirstNameValidation_EmptyName_ShouldFail() {
        viewModel.firstName = ""
        viewModel.validateField(.firstName)
        
        XCTAssertNotNil(viewModel.firstNameError)
        XCTAssertEqual(viewModel.firstNameError, "Имя не может быть пустым")
    }
    
    func testFirstNameValidation_ShortName_ShouldFail() {
        viewModel.firstName = "A"
        viewModel.validateField(.firstName)
        
        XCTAssertNotNil(viewModel.firstNameError)
        XCTAssertEqual(viewModel.firstNameError, "Имя должно содержать минимум 2 символа")
    }
    
    func testFirstNameValidation_WithNumbers_ShouldFail() {
        viewModel.firstName = "John123"
        viewModel.validateField(.firstName)
        
        XCTAssertNotNil(viewModel.firstNameError)
        XCTAssertEqual(viewModel.firstNameError, "Имя может содержать только буквы")
    }
    
    func testFirstNameValidation_ValidName_ShouldPass() {
        viewModel.firstName = "John"
        viewModel.validateField(.firstName)
        
        XCTAssertNil(viewModel.firstNameError)
    }
    
    // MARK: - Last Name Tests
    
    func testLastNameValidation_EmptyName_ShouldFail() {
        viewModel.lastName = ""
        viewModel.validateField(.lastName)
        
        XCTAssertNotNil(viewModel.lastNameError)
        XCTAssertEqual(viewModel.lastNameError, "Фамилия не может быть пустой")
    }
    
    func testLastNameValidation_ShortName_ShouldFail() {
        viewModel.lastName = "D"
        viewModel.validateField(.lastName)
        
        XCTAssertNotNil(viewModel.lastNameError)
        XCTAssertEqual(viewModel.lastNameError, "Фамилия должна содержать минимум 2 символа")
    }
    
    func testLastNameValidation_ValidName_ShouldPass() {
        viewModel.lastName = "Doe"
        viewModel.validateField(.lastName)
        
        XCTAssertNil(viewModel.lastNameError)
    }
    
    // MARK: - Birth Date Tests
    
    func testBirthDateValidation_FutureDate_ShouldFail() {
        let futureDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        viewModel.birthDate = futureDate
        viewModel.validateField(.birthDate)
        
        XCTAssertNotNil(viewModel.birthDateError)
        XCTAssertEqual(viewModel.birthDateError, "Дата рождения не может быть в будущем")
    }
    
    func testBirthDateValidation_UnderAge_ShouldFail() {
        let recentDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())!
        viewModel.birthDate = recentDate
        viewModel.validateField(.birthDate)
        
        XCTAssertNotNil(viewModel.birthDateError)
        XCTAssertEqual(viewModel.birthDateError, "Вам должно быть минимум 18 лет")
    }
    
    func testBirthDateValidation_ValidAge_ShouldPass() {
        let validDate = Calendar.current.date(byAdding: .year, value: -25, to: Date())!
        viewModel.birthDate = validDate
        viewModel.validateField(.birthDate)
        
        XCTAssertNil(viewModel.birthDateError)
    }
    
    // MARK: - Password Tests
    
    func testPasswordValidation_EmptyPassword_ShouldFail() {
        viewModel.password = ""
        viewModel.validateField(.password)
        
        XCTAssertNotNil(viewModel.passwordError)
        XCTAssertEqual(viewModel.passwordError, "Пароль не может быть пустым")
    }
    
    func testPasswordValidation_ShortPassword_ShouldFail() {
        viewModel.password = "Pass1"
        viewModel.validateField(.password)
        
        XCTAssertNotNil(viewModel.passwordError)
        XCTAssertEqual(viewModel.passwordError, "Пароль должен содержать минимум 8 символов")
    }
    
    func testPasswordValidation_NoUpperCase_ShouldFail() {
        viewModel.password = "password123"
        viewModel.validateField(.password)
        
        XCTAssertNotNil(viewModel.passwordError)
        XCTAssertEqual(viewModel.passwordError, "Пароль должен содержать заглавные буквы")
    }
    
    func testPasswordValidation_NoLowerCase_ShouldFail() {
        viewModel.password = "PASSWORD123"
        viewModel.validateField(.password)
        
        XCTAssertNotNil(viewModel.passwordError)
        XCTAssertEqual(viewModel.passwordError, "Пароль должен содержать строчные буквы")
    }
    
    func testPasswordValidation_NoDigits_ShouldFail() {
        viewModel.password = "Password"
        viewModel.validateField(.password)
        
        XCTAssertNotNil(viewModel.passwordError)
        XCTAssertEqual(viewModel.passwordError, "Пароль должен содержать цифры")
    }
    
    func testPasswordValidation_ValidPassword_ShouldPass() {
        viewModel.password = "Password123"
        viewModel.validateField(.password)
        
        XCTAssertNil(viewModel.passwordError)
    }
    
    // MARK: - Confirm Password Tests
    
    func testConfirmPasswordValidation_Empty_ShouldFail() {
        viewModel.password = "Password123"
        viewModel.confirmPassword = ""
        viewModel.validateField(.confirmPassword)
        
        XCTAssertNotNil(viewModel.confirmPasswordError)
        XCTAssertEqual(viewModel.confirmPasswordError, "Подтвердите пароль")
    }
    
    func testConfirmPasswordValidation_Mismatch_ShouldFail() {
        viewModel.password = "Password123"
        viewModel.confirmPassword = "DifferentPass123"
        viewModel.validateField(.confirmPassword)
        
        XCTAssertNotNil(viewModel.confirmPasswordError)
        XCTAssertEqual(viewModel.confirmPasswordError, "Пароли не совпадают")
    }
    
    func testConfirmPasswordValidation_Match_ShouldPass() {
        viewModel.password = "Password123"
        viewModel.confirmPassword = "Password123"
        viewModel.validateField(.confirmPassword)
        
        XCTAssertNil(viewModel.confirmPasswordError)
    }
    
    // MARK: - Form Validation Tests
    
    func testFormValidation_AllFieldsValid_ShouldReturnTrue() {
        viewModel.firstName = "John"
        viewModel.lastName = "Doe"
        viewModel.birthDate = Calendar.current.date(byAdding: .year, value: -25, to: Date())!
        viewModel.password = "Password123"
        viewModel.confirmPassword = "Password123"
        
        XCTAssertTrue(viewModel.isFormValid)
    }
    
    func testFormValidation_InvalidFirstName_ShouldReturnFalse() {
        viewModel.firstName = "J"
        viewModel.lastName = "Doe"
        viewModel.birthDate = Calendar.current.date(byAdding: .year, value: -25, to: Date())!
        viewModel.password = "Password123"
        viewModel.confirmPassword = "Password123"
        
        XCTAssertFalse(viewModel.isFormValid)
    }
    
    // MARK: - Registration Tests
    
    func testRegistration_ValidData_ShouldSaveUser() {
        viewModel.firstName = "John"
        viewModel.lastName = "Doe"
        viewModel.birthDate = Calendar.current.date(byAdding: .year, value: -25, to: Date())!
        viewModel.password = "Password123"
        viewModel.confirmPassword = "Password123"
        
        viewModel.register()
        
        XCTAssertTrue(viewModel.isRegistrationSuccessful)
        
        let savedUser = UserStorageService.shared.loadUser()
        XCTAssertNotNil(savedUser)
        XCTAssertEqual(savedUser?.firstName, "John")
        XCTAssertEqual(savedUser?.lastName, "Doe")
    }
}

