//
//  FavoritesPresenter.swift
//  NewsAppp
//
//  Created by ios developer on 22.07.2026.
//

import Foundation

class FavoritesPresenter: FavoritesPresenterProtocol{
    weak var view: FavoritesViewProtocol?
    
    var articles: [Article] = []
    
    init(view: FavoritesViewProtocol){
        self.view = view
    }
    
    func loadFavorites() {
        articles = CoreDataManager.shared.getAllFavorites()
        view?.toggleEmptyState(isHidden: !articles.isEmpty)
        view?.reloadData()
    }
    
    func deleteArticle(at index: Int) {
        let article = articles[index]
        
        CoreDataManager.shared.deleteArticle(url: article.url)
        
        articles.remove(at: index)
        view?.toggleEmptyState(isHidden: !articles.isEmpty)
        view?.deleteRow(at: index)
    }
}


