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
            avatarContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
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
        
        /*NSLayoutConstraint.activate([
            verifiedImageView.heightAnchor.constraint(equalTo: nameLabel.heightAnchor),
            verifiedImageView.widthAnchor.constraint(equalTo: verifiedImageView.heightAnchor),
            verifiedImageView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 4),
            verifiedImageView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor)
        ])*/
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
                }
                return text
            }
            .bind(to: textView.rx.attributedText)
            .disposed(by: disposeBag)
            
    }
}
