//
//  NetworkServiceTests.swift
//  Shift-appTests
//
//  Created by Suharev Sergey on 15.10.2025.
//

import XCTest
@testable import Shift_app

final class NetworkServiceTests: XCTestCase {
    var networkService: NetworkService!
    
    override func setUp() {
        super.setUp()
        networkService = NetworkService.shared
    }
    
    override func tearDown() {
        networkService = nil
        super.tearDown()
    }
    
    func testFetchProducts_ShouldReturnProducts() async throws {
        let products = try await networkService.fetchProducts()
        
        XCTAssertFalse(products.isEmpty, "Products array should not be empty")
        
        let firstProduct = products.first
        XCTAssertNotNil(firstProduct)
        XCTAssertFalse(firstProduct!.title.isEmpty)
        XCTAssertGreaterThan(firstProduct!.price, 0)
    }
    
    func testProductPriceFormatted_ShouldReturnCorrectFormat() {
        let product = Product(
            id: 1,
            title: "Test Product",
            price: 29.99,
            description: "Test Description",
            category: "electronics",
            image: "test.jpg"
        )
        
        XCTAssertEqual(product.priceFormatted, "$29.99")
    }
}

