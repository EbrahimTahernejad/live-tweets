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
    
    lazy var searchField: SearchFieldView? = {
        let field = viewProvider?.provide(with: SearchFieldView.self, input: .init(), output: .init())
        return field
    }()
    
    lazy var cancelButton: UIBarButtonItem = {
        let item = UIBarButtonItem(systemItem: .pause)
        return item
    }()
    
    lazy var refreshButton: UIBarButtonItem = {
        let item = UIBarButtonItem(systemItem: .refresh)
        item.isEnabled = false
        return item
    }()
    
    lazy var startButton: UIBarButtonItem = {
        let item = UIBarButtonItem(systemItem: .play)
        return item
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
                
        controller.navigationItem.titleView = searchField
        layoutSubviews()
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
            case .details(let tweet):
                let cell = (tableView.dequeueReusableCell(withIdentifier: "TweetDescriptionCellView") as? TweetDescriptionCellView) ?? self.viewProvider?.provide(with: TweetDescriptionCellView.self, input: .init(), output: .init())
                cell?.viewModel.input.metrics.accept(tweet.data.public_metrics)
                return cell!
            }
            
        }
        
        searchField?.viewModel.output.query
            .map { $0 ?? "" }
            .bind(to: viewModel.filterText)
            .disposed(by: disposeBag)
        
        viewModel.data
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.state.bind { [weak self] state in
            DispatchQueue.main.async { [weak self, state] () in
                switch state {
                case .loading:
                    self?.controller?.navigationItem.rightBarButtonItem = self?.refreshButton
                case .started:
                    self?.controller?.navigationItem.rightBarButtonItem = self?.cancelButton
                case .stopped:
                    self?.controller?.navigationItem.rightBarButtonItem = self?.startButton
                case .invalid:
                    self?.controller?.navigationItem.rightBarButtonItem = nil
                }
            }
        }.disposed(by: disposeBag)
        
        startButton.rx.tap.bind(onNext: viewModel.connect).disposed(by: disposeBag)
        cancelButton.rx.tap.bind(onNext: viewModel.disconnect).disposed(by: disposeBag)
        
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        viewModel.navigateToDetails(for: indexPath)
    }
}
