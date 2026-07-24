//
//  ModuleBuilder.swift
//  NewsAppp
//
//  Created by ios developer on 16.07.2026.
//

import UIKit

protocol Builder {
    static func createHomeModule() -> UIViewController
    static func createFavoriteModule() -> UIViewController
    static func createCategoriesModule() -> UIViewController
    static func createArticleDetailModule(article: Article) -> UIViewController
}
class ModuleBuilder: Builder{
    static func createHomeModule() -> UIViewController {
        let view = HomeViewController()
        
        let networkService = NetworkManager.shared
        
        let presenter = HomePresenter(view: view, networkService: networkService)
        view.presenter = presenter
        
        return view
    }
    
    static func createFavoriteModule() -> UIViewController {
        let view = FavoritesViewController()
            
        let presenter = FavoritesPresenter(view: view)
        view.presenter = presenter
        
        return view
    }
    
    static func createCategoriesModule() -> UIViewController {
        let view = CategoriesViewController()
        let presenter = CategoriesPresenter(view: view)
        view.presenter = presenter
        return view
    }
    
    static func createArticleDetailModule(article: Article) -> UIViewController {
        let view = ArticleDetailViewController()
        let presenter = ArticleDetailPresenter(view: view, article: article)
        view.presenter = presenter
        view.hidesBottomBarWhenPushed = true
        return view
    }
}
