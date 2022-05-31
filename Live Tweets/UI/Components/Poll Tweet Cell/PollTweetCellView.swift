//
//  PollTweetCellView.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/10/1401 AP.
//

import Foundation
import UIKit
import SDWebImage

class PollTweetCellView: RootCellView<PollTweetCellViewModel> {
    override class var reuseIdentifier: String {
        return "PollTweetCellView"
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
        
    override func loadSubviews() {
        super.loadSubviews()
        
        backgroundColor = .app.background
        selectionStyle = .none
        
        contentView.addSubview(stackView)
    }
    
    override func layout() {
        super.layout()
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
        ])
    }
    
    private func addOption(_ opt: TweetPoll.PollOption) {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(style: .title)
        titleLabel.textColor = .app.label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = String(opt.label)
        
        let amountLabel = UILabel()
        amountLabel.font = .systemFont(style: .normal)
        amountLabel.textColor = .app.label
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.text = String(opt.votes)
        
        let cont = UIView()
        cont.clipsToBounds = true
        cont.layer.masksToBounds = true
        cont.layer.cornerRadius = 8
        cont.backgroundColor = .app.progress
        cont.translatesAutoresizingMaskIntoConstraints = false
        
        cont.addSubview(titleLabel)
        cont.addSubview(amountLabel)
        
        stackView.addArrangedSubview(cont)
        
        NSLayoutConstraint.activate([
            cont.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: cont.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: cont.leadingAnchor, constant: 13)
        ])
        
        NSLayoutConstraint.activate([
            amountLabel.centerYAnchor.constraint(equalTo: cont.centerYAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: cont.trailingAnchor, constant: -12)
        ])
    }
    
    override func setupViewModel() {
        super.setupViewModel()
        
        viewModel.input.poll
            .bind { [weak self] poll in
                self?.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                guard let poll = poll else { return }
                for opt in poll.options {
                    self?.addOption(opt)
                }
            }
            .disposed(by: disposeBag)
    }
}
