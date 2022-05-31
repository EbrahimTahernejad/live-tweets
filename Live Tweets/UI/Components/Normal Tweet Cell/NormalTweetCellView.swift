//
//  Normal.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import Foundation
import UIKit
import SDWebImage

class NormalTweetCellView: RootCellView<NormalTweetCellViewModel> {
    override class var reuseIdentifier: String {
        return "NormalTweetCellView"
    }
    
    lazy private var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    lazy private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(style: .title)
        label.textColor = .app.label
        return label
    }()
    
    lazy private var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(style: .subtitle)
        label.textColor = .app.label2
        return label
    }()
    
    lazy private var avatarContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.rx.methodInvoked(#selector(UIView.layoutSubviews)).bind { [view] _ in
            view.layer.cornerRadius = view.frame.size.width / 2
        }.disposed(by: disposeBag)
        return view
    }()
    
    lazy private var verifiedImageView: UIImageView = {
        let imageView = UIImageView(image: .app.checkMark)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var textAttributes: [NSAttributedString.Key: Any] = {
        return [
            .font: UIFont.systemFont(style: .normal),
            .foregroundColor: UIColor.app.label
        ]
    }()
    
    lazy private var linkAttributes: [NSAttributedString.Key: Any] = {
        return [
            .font: UIFont.systemFont(style: .normal),
            .foregroundColor: UIColor.app.hyperlink
        ]
    }()
    
    lazy private var retweetIcon: UIImageView = {
        let imageView = UIImageView(image: .app.retweet)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var retweetLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(style: .subtitle)
        label.textColor = .app.label2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func loadSubviews() {
        super.loadSubviews()
        
        backgroundColor = .app.background
        selectionStyle = .none
        
        contentView.addSubview(textView)
        contentView.addSubview(avatarContainer)
        avatarContainer.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(verifiedImageView)
        contentView.addSubview(retweetLabel)
        contentView.addSubview(retweetIcon)
    }
    
    override func layout() {
        super.layout()
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: avatarContainer.bottomAnchor, constant: 10),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            avatarContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            avatarContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 21),
            avatarContainer.widthAnchor.constraint(equalToConstant: 35),
            avatarContainer.heightAnchor.constraint(equalTo: avatarContainer.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: avatarContainer.leadingAnchor),
            avatarImageView.trailingAnchor.constraint(equalTo: avatarContainer.trailingAnchor),
            avatarImageView.topAnchor.constraint(equalTo: avatarContainer.topAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: avatarContainer.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: avatarContainer.trailingAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: usernameLabel.topAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: avatarContainer.trailingAnchor, constant: 10),
            usernameLabel.topAnchor.constraint(equalTo: avatarContainer.centerYAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            verifiedImageView.heightAnchor.constraint(equalToConstant: 14),
            verifiedImageView.widthAnchor.constraint(equalToConstant: 14),
            verifiedImageView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 4),
            verifiedImageView.bottomAnchor.constraint(equalTo: avatarContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            retweetIcon.heightAnchor.constraint(equalToConstant: 14),
            retweetIcon.widthAnchor.constraint(equalToConstant: 14),
            retweetIcon.trailingAnchor.constraint(equalTo: avatarContainer.trailingAnchor),
            retweetIcon.bottomAnchor.constraint(equalTo: avatarContainer.topAnchor, constant: -2)
        ])
        
        NSLayoutConstraint.activate([
            retweetLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            retweetLabel.bottomAnchor.constraint(equalTo: avatarContainer.topAnchor, constant: -2)
        ])
    }
    
    override func setupViewModel() {
        super.setupViewModel()
        
        viewModel.author
            .map { URL(string: $0?.profile_image_url ?? "") }
            .bind(to: avatarImageView.rx.reactiveImageUrl)
            .disposed(by: disposeBag)
        
        viewModel.author
            .map { !($0?.verified ?? true) }
            .bind(to: verifiedImageView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.author
            .map { "@" + ($0?.username ?? "") }
            .bind(to: usernameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.author
            .map { $0?.name ?? "" }
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.input.tweet
            .compactMap { $0 }
            .map { [weak self] tweet -> NSAttributedString? in
                guard let self = self else { return nil }
                let text = NSMutableAttributedString(
                    string: tweet.data.text,
                    attributes: self.textAttributes
                )
                var ranges: [RangeItem] = tweet.data.entities?.urls ?? [RangeItem]()
                ranges += tweet.data.entities?.cashtags ?? [RangeItem]()
                ranges += tweet.data.entities?.hashtags ?? [RangeItem]()
                ranges += tweet.data.entities?.mentions ?? [RangeItem]()
                for r in ranges {
                    let range = NSRange(location: r.start, length: r.end - r.start)
                    text.setAttributes(self.linkAttributes, range: range)
                    if
                        let details = r as? TweetURL,
                        let url = URL(string: details.url)
                    {
                        text.addAttributes([
                            .link: url
                        ], range: range)
                    }
                }
                return text
            }
            .bind(to: textView.rx.attributedText)
            .disposed(by: disposeBag)
    
        viewModel.input.retweeter
            .bind { [weak self] retweeter in
                guard let retweeter = retweeter else {
                    self?.retweetLabel.isHidden = true
                    self?.retweetIcon.isHidden = true
                    return
                }
                self?.retweetLabel.isHidden = false
                self?.retweetIcon.isHidden = false
                self?.retweetLabel.text = self?.viewModel.dependencies.languageService?.NormalTweet_Retweet.params(["name": retweeter.name])
            }
            .disposed(by: disposeBag)
            
    }
}
