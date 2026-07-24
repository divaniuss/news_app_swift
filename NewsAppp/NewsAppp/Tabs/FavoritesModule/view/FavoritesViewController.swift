//
//  FavoritesViewController.swift
//  NewsAppp
//
//  Created by ios developer on 22.07.2026.
//

import UIKit

class FavoritesViewController: UIViewController {
    var presenter: FavoritesPresenterProtocol!
    
    private let refreshControl = UIRefreshControl()

    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.identifier)
        table.separatorStyle = .singleLine
        return table
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No articles in favorites"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            presenter.loadFavorites()
            refreshControl.endRefreshing()
        }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
    }
    
    @objc private func refreshData() {
        presenter.loadFavorites()
        print("ref")
    }
}

extension FavoritesViewController: FavoritesViewProtocol{
    func reloadData() {
        tableView.reloadData()
        refreshControl.endRefreshing()
        
    }
    
    func toggleEmptyState(isHidden: Bool) {
        emptyLabel.isHidden = isHidden
        tableView.isHidden = !isHidden
    }
    
    func deleteRow(at index: Int) {
        let path = IndexPath(row: index, section: 0)
        tableView.deleteRows(at: [path], with: .left)
    }
}


extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate{
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedArticle = presenter.articles[indexPath.row]
        let detailVC = ModuleBuilder.createArticleDetailModule(article: selectedArticle)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){ [weak self] action, view, completionHandler in
            self?.presenter.deleteArticle(at: indexPath.row)
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

