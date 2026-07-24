//
//  MainTabBarController.swift
//  NewsAppp
//
//  Created by ios developer on 16.07.2026.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGlassAppearance()
        setupTabBar()
    }
    
    private func setupGlassAppearance() {
        if #available(iOS 26.0, *) {

        } else {
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBar.tintColor = .systemCyan
        tabBar.unselectedItemTintColor = .systemGray
    }
    
    private func setupTabBar() {
        let homeVC = ModuleBuilder.createHomeModule()
        let homeNav = UINavigationController(rootViewController: homeVC)
        
        homeNav.tabBarItem = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), tag: 0)
        
        
        let categoriesVC = ModuleBuilder.createCategoriesModule()
        let categoriesNav = UINavigationController(rootViewController: categoriesVC)
        categoriesNav.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(systemName: "list.bullet"), tag: 1)
                
        let favoritesVC = ModuleBuilder.createFavoriteModule()
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        favoritesNav.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), tag: 2)
        
        setViewControllers([homeNav, categoriesNav, favoritesNav], animated: false)
    }
}
