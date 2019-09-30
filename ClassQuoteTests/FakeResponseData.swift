//
//  FakeResponseData.swift
//  ClassQuoteTests
//
//  Created by Mélanie Obringer on 26/09/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

import Foundation

class FakeResponseData {
    // MARK: - Data
    static var quoteCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Quote", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    static let quoteIncorrectData = "erreur".data(using: .utf8)!
    
    static let imageData = "image".data(using: .utf8)!
    
    // MARK: - Response
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!
    
    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!
    
    
    // MARK: - Error
    class QuoteError: Error {}
    static let error = QuoteError()
}
