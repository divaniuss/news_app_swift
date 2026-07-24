//
//  ArticleDetailPresenter.swift
//  NewsAppp
//
//  Created by ios developer on 24.07.2026.
//


import Foundation

class ArticleDetailPresenter: ArticleDetailPresenterProtocol {
    weak var view: ArticleDetailViewProtocol?
    private let article: Article
    
    init(view: ArticleDetailViewProtocol, article: Article) {
        self.view = view
        self.article = article
    }
    
    func viewDidLoad() {
        if let url = URL(string: article.url) {
            view?.load(url: url)
        }
        checkFavoriteStatus()
    }
    
    func toggleFavorite() {
        if CoreDataManager.shared.isSaved(url: article.url) {
            CoreDataManager.shared.deleteArticle(url: article.url)
        } else {
            CoreDataManager.shared.saveArticle(title: article.title, url: article.url, urlToImage: article.urlToImage, sourceName: article.source.name)
        }
        checkFavoriteStatus()
    }
    
    private func checkFavoriteStatus() {
        let isSaved = CoreDataManager.shared.isSaved(url: article.url)
        view?.updateFavoriteButton(isSaved: isSaved)
    }
}
