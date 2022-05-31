//
//  QuoteTweetCell.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/10/1401 AP.
//

import Foundation
import UIKit
import SDWebImage

class QuoteTweetCellView: RootCellView<QuoteTweetCellViewModel> {
    override class var reuseIdentifier: String {
        return "QuoteTweetCellView"
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
    
    lazy var picView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var aspectConstraint: NSLayoutConstraint?
    
    override func loadSubviews() {
        super.loadSubviews()
        
        backgroundColor = .app.background
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(textView)
        containerView.addSubview(avatarContainer)
        avatarContainer.addSubview(avatarImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(usernameLabel)
        containerView.addSubview(verifiedImageView)
        containerView.addSubview(picView)
    }
    
    override func layout() {
        super.layout()
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: avatarContainer.bottomAnchor, constant: 10),
            textView.bottomAnchor.constraint(equalTo: picView.topAnchor, constant: -10),
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            avatarContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            avatarContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            avatarContainer.widthAnchor.constraint(equalToConstant: 16),
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
            nameLabel.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 20),
            usernameLabel.centerYAnchor.constraint(equalTo: avatarContainer.centerYAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            verifiedImageView.heightAnchor.constraint(equalToConstant: 14),
            verifiedImageView.widthAnchor.constraint(equalToConstant: 14),
            verifiedImageView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 3),
            verifiedImageView.centerYAnchor.constraint(equalTo: avatarContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            picView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            picView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            picView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        ])
        
        aspectConstraint = picView.heightAnchor.constraint(equalToConstant: 0)
        aspectConstraint?.isActive = true
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
            .map { $0?.includes?.media }
            .bind { [weak self] medias in
                guard let self = self else { return }
                guard
                    let medias = medias,
                    let media = medias.first(where: { [weak self] media in
                        return self?.viewModel.input.tweet.value?.data.attachments?.media_keys?.contains(media.media_key) ?? false
                    }),
                    let urlStr = media.url ?? media.preview_image_url,
                    let url = URL(string: urlStr)
                else {
                    self.aspectConstraint?.isActive = false
                    self.aspectConstraint = self.picView.heightAnchor.constraint(equalToConstant: 0)
                    self.aspectConstraint?.isActive = true
                    return
                }
                self.aspectConstraint?.isActive = false
                self.aspectConstraint = self.picView.heightAnchor.constraint(equalTo: self.picView.widthAnchor, multiplier: CGFloat(media.height) / CGFloat(media.width))
                self.aspectConstraint?.isActive = true
                self.picView.sd_setImage(with: url)
            }.disposed(by: disposeBag)
        
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
            
    }
}

