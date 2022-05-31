//
//  TweetDescriptionCellView.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/10/1401 AP.
//

import UIKit


class TweetDescriptionCellView: RootCellView<TweetDescriptionCellViewModel> {
    override class var reuseIdentifier: String {
        return "TweetDescriptionCellView"
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var retweetView: TextIconView? = {
        let view = viewProvider?.provide(with: TextIconView.self, input: .init(), output: .init())
        view?.viewModel.input.image.accept(.app.postRetweet)
        view?.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var likeView: TextIconView? = {
        let view = viewProvider?.provide(with: TextIconView.self, input: .init(), output: .init())
        view?.viewModel.input.image.accept(.app.postLike)
        view?.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var quoteView: TextIconView? = {
        let view = viewProvider?.provide(with: TextIconView.self, input: .init(), output: .init())
        view?.viewModel.input.image.accept(.app.postQuote)
        view?.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var commentView: TextIconView? = {
        let view = viewProvider?.provide(with: TextIconView.self, input: .init(), output: .init())
        view?.viewModel.input.image.accept(.app.postComment)
        view?.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    override func loadSubviews() {
        super.loadSubviews()
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(stackView)
        if let commentView = commentView {
            stackView.addArrangedSubview(commentView)
        }
        if let likeView = likeView {
            stackView.addArrangedSubview(likeView)
        }
        if let retweetView = retweetView {
            stackView.addArrangedSubview(retweetView)
        }
        if let quoteView = quoteView {
            stackView.addArrangedSubview(quoteView)
        }
    }
    
    override func layout() {
        super.layout()
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
        ])
    }
    
    override func setupViewModel() {
        super.setupViewModel()
        
        if let commentView = commentView {
            viewModel.replyCount.map { count -> String? in
                guard let count = count else { return nil }
                return "\(count)"
            }
            .bind(to: commentView.viewModel.input.text)
            .disposed(by: disposeBag)
        }
        if let likeView = likeView {
            viewModel.likeCount.map { count -> String? in
                guard let count = count else { return nil }
                return "\(count)"
            }
            .bind(to: likeView.viewModel.input.text)
            .disposed(by: disposeBag)
        }
        if let retweetView = retweetView {
            viewModel.retweetCount.map { count -> String? in
                guard let count = count else { return nil }
                return "\(count)"
            }
            .bind(to: retweetView.viewModel.input.text)
            .disposed(by: disposeBag)
        }
        if let quoteView = quoteView {
            viewModel.quoteCount.map { count -> String? in
                guard let count = count else { return nil }
                return "\(count)"
            }
            .bind(to: quoteView.viewModel.input.text)
            .disposed(by: disposeBag)
        }
    }
}
