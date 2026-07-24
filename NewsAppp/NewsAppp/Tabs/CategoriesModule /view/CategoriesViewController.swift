//
//  CategoriesViewController.swift
//  NewsAppp
//
//  Created by ios developer on 23.07.2026.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    var presenter: CategoriesPresenterProtocol!
    
    private let refreshControl = UIRefreshControl()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        
        return collection
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.identifier)
        table.separatorStyle = .singleLine
        return table
    }()
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        let firstIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: firstIndexPath, animated: true, scrollPosition: .left)
        
        if let firstCategory = presenter.categories.first {
            presenter.loadNews(for: firstCategory)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            
        let gradient = CAGradientLayer()
        gradient.frame = blurEffectView.bounds
            
        gradient.colors = [
            UIColor.black.cgColor,
            UIColor.black.cgColor,
            UIColor.clear.cgColor
        ]
        gradient.locations = [0.0, 0.7, 1.0]
        
        blurEffectView.layer.mask = gradient
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(blurEffectView)
        view.addSubview(collectionView)
        
        
        refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
        
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func refreshNews() {
        presenter.refreshData()
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

extension CategoriesViewController: CategoriesViewProtocol {
    func reloadTableData() {
        tableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.tableView.tableFooterView = nil
        }
    }
    
    func showError(message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.tableView.tableFooterView = nil
            print("error fetch category or news - \(message)")
        }
    }
    
    func endRefreshing(){
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
}

extension CategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.categories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
                return UICollectionViewCell()
            }
        let categoryName = presenter.categories[indexPath.item]
        cell.configure(with: categoryName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = presenter.categories[indexPath.item]
        presenter.loadNews(for: selectedCategory)
    }
}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
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
