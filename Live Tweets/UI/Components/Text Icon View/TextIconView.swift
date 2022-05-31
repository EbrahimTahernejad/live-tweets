//
//  TextIconView.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/10/1401 AP.
//

import UIKit
import RxCocoa


class TextIconView: RootView<TextIconViewModel> {
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 7
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var iconView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var textLabel: UILabel = {
        let textLabel: UILabel = UILabel()
        textLabel.font = .systemFont(style: .normal)
        textLabel.textColor = .app.label2
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
        
    override func loadSubviews() {
        super.loadSubviews()
        
        backgroundColor = .app.background
        
        addSubview(stackView)
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(textLabel)
    }
    
    override func layout() {
        super.layout()
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 24),
            iconView.widthAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    override func setupViewModel() {
        super.setupViewModel()
        
        viewModel.input.text.bind(to: textLabel.rx.text).disposed(by: disposeBag)
        viewModel.input.image.bind(to: iconView.rx.image).disposed(by: disposeBag)
        
    }
}
