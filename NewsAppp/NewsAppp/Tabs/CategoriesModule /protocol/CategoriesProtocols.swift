//
//  CategoriesProtocols.swift
//  NewsAppp
//
//  Created by ios developer on 23.07.2026.
//

import Foundation

protocol CategoriesPresenterProtocol {
    var categories: [String] { get }
    var articles: [Article] {get}
    func loadNews(for category: String)
    func refreshData()
    func isSaved(article: Article) -> Bool
    func toggleFavorite(article: Article)
}


protocol CategoriesViewProtocol: AnyObject  {
    func reloadTableData()
    func showError(message: String)
    func endRefreshing()
}
