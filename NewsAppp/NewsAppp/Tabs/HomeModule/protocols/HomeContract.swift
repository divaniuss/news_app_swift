//
//  HomeContract.swift
//  NewsAppp
//
//  Created by ios developer on 16.07.2026.
//

import Foundation

protocol HomeViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol HomePresenterProtocol: AnyObject {
    func getNews()
    func search(query: String)
    var articles: [Article] { get }
}
