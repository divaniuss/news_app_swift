//
//  FavoritesProtocol.swift
//  NewsAppp
//
//  Created by ios developer on 22.07.2026.
//

import Foundation

protocol FavoritesViewProtocol: AnyObject{
    func reloadData()
    func toggleEmptyState(isHidden: Bool)
    func deleteRow(at index: Int)
}

protocol FavoritesPresenterProtocol{
    var articles: [Article] { get }
    func loadFavorites()
    func deleteArticle(at index: Int)
}
