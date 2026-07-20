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
    
    required init(view: HomeViewProtocol, networkService: NetworkManager) {
        self.view = view
        self.networkService = networkService
    }
    
    func getNews() {
        networkService.fetchTopHeadlines { [weak self] result in
            guard let self = self else { return }
            
            switch result{
            case.success(let articles):
                self.articles = articles
                self.view?.success()
            case.failure(let error):
                self.view?.failure(error: error)
            }
        }
        
    }
}
