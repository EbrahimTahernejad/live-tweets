//
//  TweetListView.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import UIKit
import RxDataSources


class TweetListView: RootView<TweetListViewModel> {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override func loadSubviews() {
        super.loadSubviews()
        
        backgroundColor = .app.background
        tableView.backgroundColor = .app.background
        tableView.separatorStyle = .none
        tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        tableView.keyboardDismissMode = .onDrag
        addSubview(tableView)
    }
    
    override func setup(controller: UIViewController) {
        super.setup(controller: controller)
        
        print("SetupViewModel?")
        
        let field = UITextField()
        field.placeholder = "do it"
        field.rx.text.map{ $0 ?? "" }.bind(to: viewModel.filterText).disposed(by: disposeBag)
        field.borderStyle = .roundedRect
        controller.navigationItem.titleView = field
        
        let item = UIBarButtonItem(systemItem: .close)
        item.rx.tap.bind { [unowned self] _ in
            viewModel.disconnect()
        }.disposed(by: disposeBag)
        controller.navigationItem.rightBarButtonItem = item
    }
    
    override func layout() {
        super.layout()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    
    override func setupViewModel() {
        super.setupViewModel()
                
        let dataSource = RxTableViewSectionedAnimatedDataSource<SectionOfData>.init{ [weak self] dataSource, tableView, indexPath, item in
            guard let self = self else { return UITableViewCell() }
            switch item {
            case .normal(let tweet, let retweeter):
                let cell = (tableView.dequeueReusableCell(withIdentifier: "NormalTweetCellView") as? NormalTweetCellView) ?? self.viewProvider?.provide(with: NormalTweetCellView.self, input: .init(), output: .init())
                cell?.viewModel.input.tweet.accept(tweet)
                cell?.viewModel.input.retweeter.accept(retweeter)
                return cell!
            case .media(let media):
                let cell = (tableView.dequeueReusableCell(withIdentifier: "MediaTweetCellView") as? MediaTweetCellView) ?? self.viewProvider?.provide(with: MediaTweetCellView.self, input: .init(), output: .init())
                cell?.viewModel.input.media.accept(media)
                return cell!
            case .url(let url):
                let cell = (tableView.dequeueReusableCell(withIdentifier: "URLTweetCellView") as? URLTweetCellView) ?? self.viewProvider?.provide(with: URLTweetCellView.self, input: .init(), output: .init())
                cell?.viewModel.input.url.accept(url)
                return cell!
            case .quoted(let tweet):
                let cell = (tableView.dequeueReusableCell(withIdentifier: "QuoteTweetCellView") as? QuoteTweetCellView) ?? self.viewProvider?.provide(with: QuoteTweetCellView.self, input: .init(), output: .init())
                cell?.viewModel.input.tweet.accept(tweet)
                return cell!
            case .poll(let poll):
                let cell = (tableView.dequeueReusableCell(withIdentifier: "PollTweetCellView") as? PollTweetCellView) ?? self.viewProvider?.provide(with: PollTweetCellView.self, input: .init(), output: .init())
                cell?.viewModel.input.poll.accept(poll)
                return cell!
            }
            
        }
        
        viewModel.data
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
}

extension TweetListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        1
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .app.label2.withAlphaComponent(0.2)
        return footer
    }
}
