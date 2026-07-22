//
//  HomeViewController.swift
//  NewsAppp
//
//  Created by ios developer on 16.07.2026.
//

import UIKit
import SafariServices

class HomeViewController: UIViewController {
    
    var presenter: HomePresenterProtocol!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
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
        setupSearchController()
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
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search.."
        
        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
    }
    
    @objc private func refreshData() {
        presenter.getNews()
    }
}

extension HomeViewController: HomeViewProtocol {
    func success() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    func failure(error: Error) {
        print("Ошибка сети: \(error.localizedDescription)")
        refreshControl.endRefreshing()
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
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let article = presenter.articles[indexPath.row]
        
        let isSaved = presenter.isSaved(article: article)
        
        let actionTitle = isSaved ? "Delete" : "To Favorite"
        let actionIcon = isSaved ? "trash.fill" : "star.fill"
        let actionColor = isSaved ? UIColor.systemRed : UIColor.systemCyan
        let actionStyle: UIContextualAction.Style = isSaved ? .destructive : .normal
        
        let action = UIContextualAction(style: actionStyle, title: actionTitle) { [weak self] (action, view, completionHandler) in
            self?.presenter.toggleFavorite(article: article)
            completionHandler(true)
        }
        
        action.backgroundColor = actionColor
        action.image = UIImage(systemName: actionIcon)
        
    
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = true

        return configuration
    }
}


extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text =  searchController.searchBar.text else { return }
        
        presenter.search(query: text)
    }
}
//ДОДЕЛАТЬ С WKWebView ОКНО НА НОВОСТЬ
