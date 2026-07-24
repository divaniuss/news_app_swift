//
//  CategoryCell.swift
//  NewsAppp
//
//  Created by ios developer on 23.07.2026.
//
import UIKit

final class CategoryCell: UICollectionViewCell{
    static let identifier = "CategoryCell"
    
    
    
    private let glassView: UIVisualEffectView = {
            
        let view: UIVisualEffectView
        if #available(iOS 26.0, *) {
            let glassEffect = UIGlassEffect(style: .regular)
            view = UIVisualEffectView(effect: glassEffect)
        } else {
            let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            view = UIVisualEffectView(effect: blurEffect)
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        
        return view
    }()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(glassView)
        glassView.contentView.addSubview(titleLabel)
        
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        
        NSLayoutConstraint.activate([
            glassView.topAnchor.constraint(equalTo: contentView.topAnchor),
            glassView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            glassView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            glassView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: glassView.contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: glassView.contentView.bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: glassView.contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: glassView.contentView.trailingAnchor, constant: -16)
        ])
    }
    override var isSelected: Bool{
        didSet {
            UIView.animate(withDuration: 0.2){
                if #available(iOS 26.0, *){
                    if let glassEffect = self.glassView.effect as? UIGlassEffect {
                        glassEffect.tintColor = self.isSelected ? UIColor.systemCyan.withAlphaComponent(0.5) : .clear
                        self.glassView.effect = glassEffect
                    }
                } else {
                    self.glassView.contentView.backgroundColor = self.isSelected ? UIColor.systemCyan.withAlphaComponent(0.5) : .clear
                }
            }
            
        }
    }
    func configure(with title: String){
        titleLabel.text = title.capitalized
    }
}

