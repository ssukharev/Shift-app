//
//  UserStorageServiceTests.swift
//  Shift-appTests
//
//  Created by Suharev Sergey on 15.10.2025.
//

import XCTest
@testable import Shift_app

final class UserStorageServiceTests: XCTestCase {
    var userStorage: UserStorageService!
    
    override func setUp() {
        super.setUp()
        userStorage = UserStorageService.shared
        userStorage.clearUser()
    }
    
    override func tearDown() {
        userStorage.clearUser()
        userStorage = nil
        super.tearDown()
    }
    
    func testSaveUser_ShouldPersistUserData() {
        let user = User(
            firstName: "John",
            lastName: "Doe",
            birthDate: Date()
        )
        
        userStorage.saveUser(user)
        
        let loadedUser = userStorage.loadUser()
        XCTAssertNotNil(loadedUser)
        XCTAssertEqual(loadedUser?.firstName, "John")
        XCTAssertEqual(loadedUser?.lastName, "Doe")
    }
    
    func testLoadUser_NoUserSaved_ShouldReturnNil() {
        let user = userStorage.loadUser()
        XCTAssertNil(user)
    }
    
    func testIsUserRegistered_UserSaved_ShouldReturnTrue() {
        let user = User(
            firstName: "John",
            lastName: "Doe",
            birthDate: Date()
        )
        
        userStorage.saveUser(user)
        
        XCTAssertTrue(userStorage.isUserRegistered())
    }
    
    func testIsUserRegistered_NoUserSaved_ShouldReturnFalse() {
        XCTAssertFalse(userStorage.isUserRegistered())
    }
    
    func testClearUser_ShouldRemoveUserData() {
        let user = User(
            firstName: "John",
            lastName: "Doe",
            birthDate: Date()
        )
        
        userStorage.saveUser(user)
        XCTAssertNotNil(userStorage.loadUser())
        
        userStorage.clearUser()
        XCTAssertNil(userStorage.loadUser())
    }
    
    func testUserFullName_ShouldCombineFirstAndLastName() {
        let user = User(
            firstName: "John",
            lastName: "Doe",
            birthDate: Date()
        )
        
        XCTAssertEqual(user.fullName, "John Doe")
    }
}

