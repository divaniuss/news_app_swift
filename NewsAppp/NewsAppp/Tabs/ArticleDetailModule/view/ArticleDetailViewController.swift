//
//  ArticleDetailViewController.swift
//  NewsAppp
//
//  Created by ios developer on 24.07.2026.
//


import UIKit
import WebKit

final class ArticleDetailViewController: UIViewController {
    var presenter: ArticleDetailPresenterProtocol!
    
    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Не удалось загрузить страницу.\nПроверьте подключение к интернету."
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        webView.alpha = 0
        
        view.addSubview(webView)
        view.addSubview(spinner)
        view.addSubview(errorLabel)
        
        webView.navigationDelegate = self
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
                
        ])
    }
    
    @objc private func favoriteButtonTapped() {
        presenter.toggleFavorite()
    }
}

extension ArticleDetailViewController: ArticleDetailViewProtocol {
    func load(url: URL) {
        errorLabel.isHidden = true
        webView.alpha = 0
        spinner.startAnimating()
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
    
    func updateFavoriteButton(isSaved: Bool) {
        let iconName = isSaved ? "star.fill" : "star"
        let color = isSaved ? UIColor.systemCyan : UIColor.label
        
        let favoriteButton = UIBarButtonItem(
            image: UIImage(systemName: iconName),
            style: .plain,
            target: self,
            action: #selector(favoriteButtonTapped)
        )
        favoriteButton.tintColor = color
        navigationItem.rightBarButtonItem = favoriteButton
    }
}


extension ArticleDetailViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
        errorLabel.isHidden = true
        
        UIView.animate(withDuration: 0.3) {
            self.webView.alpha = 1
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        spinner.stopAnimating()
        errorLabel.isHidden = false
        webView.alpha = 0
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        spinner.stopAnimating()
        errorLabel.isHidden = false
        webView.alpha = 0
    }
}
