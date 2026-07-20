//
//  HomeViewController.swift
//  NewsAppp
//
//  Created by ios developer on 16.07.2026.
//

import UIKit

class HomeViewController: UIViewController {
    
    var presenter: HomePresenterProtocol!
    
    private let refreshControl = UIRefreshControl()
        
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.identifier)
        table.separatorStyle = .singleLine
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
//        title = "news"
        
        setupTableView()
        presenter.getNews()
        
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc private func refreshData() {
        presenter.getNews()
        refreshControl.endRefreshing()
    }
}

extension HomeViewController: HomeViewProtocol {
    func success() {
        tableView.reloadData()
    }
    func failure(error: Error) {
        print("Ошибка сети: \(error.localizedDescription)")
    }
}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.articles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.identifier, for: indexPath) as? ArticleCell else {
            return UITableViewCell()
        }
        let article = presenter.articles[indexPath.row]
        
        cell.configure(with: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedArticle = presenter.articles[indexPath.row]
        print("нажали на \(selectedArticle.title)")
    }
}
