//
//  ArticleDetailViewProtocol.swift
//  NewsAppp
//
//  Created by ios developer on 24.07.2026.
//


import Foundation

protocol ArticleDetailViewProtocol: AnyObject {
    func load(url: URL)
    func updateFavoriteButton(isSaved: Bool)
}

protocol ArticleDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func toggleFavorite()
}