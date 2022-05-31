//
//  MediaTweetCellView.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/10/1401 AP.
//

import Foundation
import UIKit
import SDWebImage

class MediaTweetCellView: RootCellView<MediaTweetCellViewModel> {
    override class var reuseIdentifier: String {
        return "MediaTweetCellView"
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .app.progress
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
        return imageView
    }()
    
    var aspectConstraint: NSLayoutConstraint?
    
    override func loadSubviews() {
        super.loadSubviews()
        
        backgroundColor = .app.background
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(picView)
    }
    
    override func layout() {
        super.layout()
        
        NSLayoutConstraint.activate([
            picView.topAnchor.constraint(equalTo: containerView.topAnchor),
            picView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            picView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            picView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        aspectConstraint = containerView.widthAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1)
        aspectConstraint?.isActive = true
    }
    
    override func setupViewModel() {
        super.setupViewModel()
        
        viewModel.input.media
            .map { media -> String? in
                guard let media = media else { return nil }
                switch media.type {
                case .photo:
                    return media.url
                case .animated_gif, .video:
                    return media.preview_image_url
                }
            }
            .map { URL(string: $0 ?? "") }
            .bind(to: picView.rx.reactiveImageUrl)
            .disposed(by: disposeBag)
        
        viewModel.input.media
            .map { media -> CGFloat in
                guard let media = media else { return 1.0 }
                let aspect = CGFloat(media.width) / CGFloat(media.height)
                return aspect
            }.bind { [weak self] aspect in
                guard let self = self else { return }
                self.aspectConstraint?.isActive = false
                self.aspectConstraint = self.containerView.widthAnchor.constraint(equalTo: self.containerView.heightAnchor, multiplier: aspect)
                self.aspectConstraint?.isActive = true
            }.disposed(by: disposeBag)
    }
}

