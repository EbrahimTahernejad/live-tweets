//
//  TweetListView.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import UIKit
import RxDataSources

struct SectionOfData {
    var items: [Item]
}

extension SectionOfData: SectionModelType {
    typealias Item = TweetCellType

    init(original: SectionOfData, items: [Item]) {
        self = original
        self.items = items
    }
}

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
                
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfData>.init{ [weak self] dataSource, tableView, indexPath, item in
            guard let self = self else { return UITableViewCell() }
            switch item {
            case .normal(let tweet, let retweeter):
                let cell = (tableView.dequeueReusableCell(withIdentifier: "NormalTweetCellView") as? NormalTweetCellView) ?? self.viewProvider?.provide(with: NormalTweetCellView.self, input: .init(), output: .init())
                cell?.viewModel.input.tweet.accept(tweet)
                cell?.viewModel.input.retweeter.accept(retweeter)
                return cell!
            case .quoted(_), .url(_), .media(_), .poll(_):
                return tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") ?? UITableViewCell(style: .default, reuseIdentifier: "UITableViewCell")
            }
            
        }
        
        viewModel.data
            .map { $0.map { SectionOfData(items: $0) } }
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
