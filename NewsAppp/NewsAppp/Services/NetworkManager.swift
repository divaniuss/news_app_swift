//
//  NetworkManager.swift
//  NewsAppp
//
//  Created by ios developer on 16.07.2026.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case missingKey
}


final class NetworkManager{
    
    static let shared = NetworkManager()
    private init(){}
    
    private var apiKey: String? {
        return Bundle.main.infoDictionary?["API_KEY"] as? String
    }
    
    func fetchTopHeadlines(category: String?, page: Int = 1, completion: @escaping (Result<[Article],NetworkError>) -> Void) {
        guard let key = apiKey, !key.isEmpty else {
            DispatchQueue.main.async {
                completion(.failure(.missingKey))
            }
            return
        }
        
        var components = URLComponents(string: "https://newsapi.org/v2/top-headlines")
        var queryItems = [URLQueryItem(name: "country", value: "us"),
                          URLQueryItem(name: "page", value: "\(page)")]
        
        if let category = category {
            queryItems.append(URLQueryItem(name: "category", value: category))
        }
        
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            DispatchQueue.main.async {
                completion(.failure(.invalidURL))
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(key, forHTTPHeaderField: "x-api-key")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            do {
                let newResponse = try JSONDecoder().decode(NewResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(newResponse.articles))
                }
            }catch{
                print("error - \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
                    
            }
        }
        task.resume()
        
    }
    
    func searchNews(query: String, page: Int = 1, completion: @escaping (Result<[Article], NetworkError>) -> Void){
        guard let key = apiKey, !key.isEmpty else {
            DispatchQueue.main.async {
                completion(.failure(.missingKey))
            }
            return
        }
        var components = URLComponents(string: "https://newsapi.org/v2/everything")
        components?.queryItems = [URLQueryItem(name: "q", value: query),
                                  URLQueryItem(name: "language", value: "en"),
                                  URLQueryItem(name: "page", value: "\(page)")]
        
        guard let url = components?.url else {
            DispatchQueue.main.async {
                completion(.failure(.invalidURL))
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(key, forHTTPHeaderField: "x-api-key")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                let newResponse = try JSONDecoder().decode(NewResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(newResponse.articles))
                }
            }catch{
                print("error - \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }

            }
        }
        task.resume()
    }
}

