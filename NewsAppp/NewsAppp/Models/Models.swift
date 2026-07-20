//
//  models.swift
//  NewsAppp
//
//  Created by ios developer on 16.07.2026.
//

import Foundation

struct NewResponse: Codable{
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Source: Codable {
    let id: String?
    let name: String
}

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}


