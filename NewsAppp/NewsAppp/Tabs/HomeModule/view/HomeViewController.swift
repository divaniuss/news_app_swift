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
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "По вашему запросу ничего не найдено"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.isHidden = true // Скрыт по умолчанию
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        view.addSubview(emptyStateLabel)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
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
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
}

extension HomeViewController: HomeViewProtocol {
    func success() {
        tableView.reloadData()
        
        emptyStateLabel.isHidden = !presenter.articles.isEmpty
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.tableView.tableFooterView = nil
            self?.refreshControl.endRefreshing()
        }
    }
    func failure(error: Error) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.tableView.tableFooterView = nil
            print("Ошибка сети: \(error.localizedDescription)")
            self?.refreshControl.endRefreshing()
        }
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
        let detailVC = ModuleBuilder.createArticleDetailModule(article: selectedArticle)
        navigationController?.pushViewController(detailVC, animated: true)
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItemIndex = presenter.articles.count - 1
        if indexPath.row == lastItemIndex {
            tableView.tableFooterView = createSpinnerFooter()
            presenter.loadNextPage()
        }
    }
}


extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text =  searchController.searchBar.text else { return }
        emptyStateLabel.isHidden = true
        presenter.search(query: text)
    }
}
