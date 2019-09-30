//
//  ClassQuoteTests.swift
//  ClassQuoteTests
//
//  Created by Mélanie Obringer on 26/08/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

import XCTest
@testable import ClassQuote

class ClassQuoteTests: XCTestCase {
    // test callback error
    func testGetQuoteShouldPostFailedCallback() {
        // Given
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error),
            imageSession: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        quoteService.getQuote { (success, quote) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test if there's no data
    func testGetQuoteShouldPostFailedCallbackIfNoData() {
        // Given
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(data: nil, response: nil, error: nil),
            imageSession: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        quoteService.getQuote { (success, quote) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test if response is incorrect for the image
    func testGetQuoteShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(
                data: FakeResponseData.quoteCorrectData,
                response: FakeResponseData.responseKO,
                error: nil),
            imageSession: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        quoteService.getQuote { (success, quote) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test if there's incorrect data for the image
    func testGetQuoteShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(
                data: FakeResponseData.quoteIncorrectData,
                response: FakeResponseData.responseOK,
                error: nil),
            imageSession: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        quoteService.getQuote { (success, quote) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    // test if there's no picture data
    func testGetQuoteShouldPostFailedNotificationIfNoPictureData() {
        // Given
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(
                data: FakeResponseData.quoteCorrectData,
                response: FakeResponseData.responseOK,
                error: nil),
            imageSession: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        quoteService.getQuote { (success, quote) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    // test if there's an notification error for the picture
    func testGetQuoteShouldPostFailedNotificationIfErrorWhileRetrievingPicture() {
        // Given
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(
                data: FakeResponseData.quoteCorrectData,
                response: FakeResponseData.responseOK,
                error: nil),
            imageSession: URLSessionFake(
                data: FakeResponseData.imageData,
                response: FakeResponseData.responseOK,
                error: FakeResponseData.error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        quoteService.getQuote { (success, quote) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    // test if there's an incorrect response for the picture
    func testGetQuoteShouldPostFailedNotificationIfIncorrectResponseWhileRetrievingPicture() {
        // Given
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(
                data: FakeResponseData.quoteCorrectData,
                response: FakeResponseData.responseOK,
                error: nil),
            imageSession: URLSessionFake(
                data: FakeResponseData.imageData,
                response: FakeResponseData.responseKO,
                error: FakeResponseData.error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        quoteService.getQuote { (success, quote) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // test if there's no error and correct response and data for the quote and the image
    func testGetQuoteShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(
                data: FakeResponseData.quoteCorrectData,
                response: FakeResponseData.responseOK,
                error: nil),
            imageSession: URLSessionFake(
                data: FakeResponseData.imageData,
                response: FakeResponseData.responseOK,
                error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        quoteService.getQuote { (success, quote) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(quote)
            
            let text = "Be not afraid of greatness: some are born great, some achieve greatness, and some have greatness thrust upon them.  "
            let author = "William Shakespeare "
            let imageData = "image".data(using: .utf8)!
            
            XCTAssertEqual(text, quote!.text)
            XCTAssertEqual(author, quote!.author)
            XCTAssertEqual(imageData, quote!.imageData)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
