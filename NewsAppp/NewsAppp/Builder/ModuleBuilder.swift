//
//  ModuleBuilder.swift
//  NewsAppp
//
//  Created by ios developer on 16.07.2026.
//

import UIKit

protocol Builder {
    static func createHomeModule() -> UIViewController
}
class ModuleBuilder: Builder{
    static func createHomeModule() -> UIViewController {
        let view = HomeViewController()
        
        let networkService = NetworkManager.shared
        
        let presenter = HomePresenter(view: view, networkService: networkService)
        view.presenter = presenter
        
        return view
    }
}
