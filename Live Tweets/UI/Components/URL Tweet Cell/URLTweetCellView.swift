//
//  URLTweetCellView.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/10/1401 AP.
//

import UIKit

import Foundation
import UIKit
import SDWebImage

class URLTweetCellView: RootCellView<URLTweetCellViewModel> {
    override class var reuseIdentifier: String {
        return "URLTweetCellView"
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.app.label2.withAlphaComponent(0.17).cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var picView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(style: .normal)
        label.textColor = .app.label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var urlLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(style: .normal)
        label.textColor = .app.label2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func loadSubviews() {
        super.loadSubviews()
        
        backgroundColor = .app.background
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(picView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(urlLabel)
    }
    
    override func layout() {
        super.layout()
        
        NSLayoutConstraint.activate([
            picView.topAnchor.constraint(equalTo: containerView.topAnchor),
            picView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            picView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            picView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            containerView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: picView.trailingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            titleLabel.bottomAnchor.constraint(equalTo: picView.centerYAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            urlLabel.leadingAnchor.constraint(equalTo: picView.trailingAnchor, constant: 15),
            urlLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            urlLabel.topAnchor.constraint(equalTo: picView.centerYAnchor, constant: 0),
        ])
        
    }
    
    override func setupViewModel() {
        super.setupViewModel()
        
        viewModel.input.url
            .map { $0?.display_url }
            .bind(to: urlLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.input.url
            .map { $0?.title }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.input.url
            .compactMap { $0?.images?.first?.url }
            .map { URL(string: $0) }
            .bind(to: picView.rx.reactiveImageUrl)
            .disposed(by: disposeBag)
    }
}
