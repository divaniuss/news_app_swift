//
//  CategoriesPresenter.swift
//  NewsAppp
//
//  Created by ios developer on 23.07.2026.
//

import Foundation

class CategoriesPresenter: CategoriesPresenterProtocol {
    weak var view: CategoriesViewProtocol?
    
    var articles: [Article] = []
    
    let categories = ["business", "entertainment", "general", "health", "science", "sports", "technology"]
    
    private var currentCategory: String = "business"
    
    init(view: CategoriesViewProtocol) {
        self.view = view
    }
    
    func loadNews(for category: String) {
        currentCategory = category
        
        let formatCategory = category.lowercased()
        
        NetworkManager.shared.fetchTopHeadlines(category: formatCategory) { [weak self] result in
            
            self?.view?.endRefreshing()
            switch result {
            case .success(let fetchedArticles):
                self?.articles = fetchedArticles
                self?.view?.reloadTableData()
            case .failure(let error):
                self?.view?.showError(message: error.localizedDescription)
            }
        }
    }
    
    func refreshData() {
        loadNews(for: currentCategory)
    }
    
    
    func isSaved(article: Article) -> Bool {
        return CoreDataManager.shared.isSaved(url: article.url)
    }
    
    func toggleFavorite(article: Article) {
        if CoreDataManager.shared.isSaved(url: article.url){
            CoreDataManager.shared.deleteArticle(url: article.url)
        } else {
            CoreDataManager.shared.saveArticle(title: article.title, url: article.url, urlToImage: article.urlToImage, sourceName: article.source.name)
        }
    }
}
