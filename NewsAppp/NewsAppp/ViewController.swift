//
//  ViewController.swift
//  NewsAppp
//
//  Created by ios developer on 16.07.2026.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        // Запускаем тест сети сразу после загрузки экрана
        testNetworkManager()
    }
    
    private func testNetworkManager() {
        print("Начинаем загрузку новостей...")
        
        NetworkManager.shared.fetchTopHeadlines { result in
            switch result {
            case .success(let articles):
                print("Успешно загружено новостей: \(articles.count)")
                
                // Выведем первые 3 новости, чтобы не засорять консоль
                for (index, article) in articles.prefix(3).enumerated() {
                    print("\n--- Новость \(index + 1) ---")
                    print("Заголовок: \(article.title)")
                    print("Источник: \(article.source.name)")
                }
                
            case .failure(let error):
                print("Ошибка загрузки: \(error)")
            }
        }
    }
}

