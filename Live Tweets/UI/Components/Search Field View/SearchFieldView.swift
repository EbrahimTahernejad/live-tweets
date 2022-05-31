//
//  SearchFieldView.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/10/1401 AP.
//

import UIKit

class SearchFieldView: RootView<SearchFieldViewModel> {
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    lazy var container: UIView = {
        let container = UIView()
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.app.label2.withAlphaComponent(0.17).cgColor
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.placeholder = viewModel.dependencies.languageService?.SearchField_Placeholder
        textField.font = .systemFont(style: .normal)
        textField.textColor = .app.label
        return textField
    }()
    
    override func loadSubviews() {
        super.loadSubviews()
        
        addSubview(container)
        container.addSubview(textField)
    }
    
    override func layout() {
        super.layout()
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: container.topAnchor, constant: 0),
            textField.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0),
            textField.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15),
            textField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15),
        ])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        container.layer.cornerRadius = container.frame.size.height / 2
    }
    
    override func setupViewModel() {
        super.setupViewModel()
        
        textField.rx.text
            .bind(to: viewModel.output.query)
            .disposed(by: disposeBag)
    }
}
