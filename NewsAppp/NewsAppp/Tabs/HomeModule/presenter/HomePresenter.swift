//
//  HomePresenter.swift
//  NewsAppp
//
//  Created by ios developer on 16.07.2026.
//

import Foundation

class HomePresenter: HomePresenterProtocol {
    weak var view: HomeViewProtocol?
    let networkService: NetworkManager
    var articles: [Article] = []
    
    private var searchTimer: Timer?
    
    private var currentPage = 1
    private var isFetching = false
    private var isLastPage = false
    private var currentSearchQuery: String? = nil
    
    required init(view: HomeViewProtocol, networkService: NetworkManager) {
        self.view = view
        self.networkService = networkService
    }
    
    func getNews() {
        currentPage = 1
        isLastPage = false
        currentSearchQuery = nil
        isFetching = true
        
        networkService.fetchTopHeadlines(category: nil) { [weak self] result in
            guard let self = self else { return }
            
            self.isFetching = false
            
            switch result{
            case .success(let articles):
                self.articles = articles
                self.view?.success()
            case .failure(let error):
                self.view?.failure(error: error)
            }
        }
        
    }
    
    func search(query: String) {
        searchTimer?.invalidate( )
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            getNews()
            return
        }
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self else {return}
            
            self.currentPage = 1
            self.isLastPage = false
            self.currentSearchQuery = query
            self.isFetching = true
            
            self.networkService.searchNews(query: query) { [weak self ] result in
                guard let self = self else {return}
                
                self.isFetching = false
                
                switch result{
                case .success(let articles):
                    self.articles = articles
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            
            }
        }
            
    }
    
    func loadNextPage(){
        guard !isFetching, !isLastPage else { return }
        
        isFetching = true
        currentPage += 1
        
        if let query = currentSearchQuery {
            networkService.searchNews(query: query, page: currentPage) { [weak self] result in
                self?.handleNextPageResult(result)
                }
            } else {
                networkService.fetchTopHeadlines(category: nil, page: currentPage) { [weak self] result in
                    self?.handleNextPageResult(result)
                }
            }
    }
    
    private func handleNextPageResult(_ result: Result<[Article], NetworkError>) {
        isFetching = false
            
        switch result {
        case .success(let newArticles):
            if newArticles.isEmpty {
                isLastPage = true
                return
            }
            self.articles.append(contentsOf: newArticles)
            self.view?.success()
        case .failure(let error):
            self.view?.failure(error: error)
            }
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
