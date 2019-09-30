//
//  QuoteService.swift
//  ClassQuote
//
//  Created by Mélanie Obringer on 26/08/2019.
//  Copyright © 2019 Mélanie Obringer. All rights reserved.
//

import Foundation

class QuoteService {
    static var shared = QuoteService()
    private init() {}
    
    private static let quoteUrl = URL(string: "http://api.forismatic.com/api/1.0/")!
    private static let pictureUrl = URL(string: "https://source.unsplash.com/random/1000x1000")!
    private var task: URLSessionDataTask?
    
    // injections de dépendance
    private var quoteSession = URLSession(configuration: .default)
    private var imageSession = URLSession(configuration: .default)
    
    init(quoteSession: URLSession, imageSession: URLSession) {
        self.quoteSession = quoteSession
        self.imageSession = imageSession
    }
    
    func getQuote(callback: @escaping (Bool, Quote?) -> Void) {
        // URL, method, parameters
        var request = URLRequest(url: QuoteService.quoteUrl)
        request.httpMethod = "POST"
        
        let body = "method=getQuote&format=json&lang=en"
        request.httpBody = body.data(using: .utf8)
        
        
        task?.cancel()
        task = quoteSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode([String: String].self, from: data),
                    let text = responseJSON["quoteText"],
                    let author = responseJSON["quoteAuthor"] else {
                        callback(false, nil)
                        return
                }
                self.getImage { (data) in
                    guard let data = data else {
                        callback(false, nil)
                        return
                    }
                    let quote = Quote(text: text, author: author, imageData: data)
                    callback(true, quote)
                }
            }
        }
        task?.resume()
    }
    
    func getImage(completionHandler: @escaping (Data?) -> Void) {
        
        task?.cancel()
        task = imageSession.dataTask(with: QuoteService.pictureUrl) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completionHandler(nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(nil)
                    return
                }
                completionHandler(data)
            }
        }
        task?.resume()
    }
}

