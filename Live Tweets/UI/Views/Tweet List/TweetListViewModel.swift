//
//  TweetListViewModel.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import Foundation
import RxCocoa
import RxSwift


class TweetListViewModel: BaseViewModel<EmptyIO, EmptyIO> {
    
    override class var inject: DependencyOptions {
        [.router, .apiRulesService]
    }
    
    let searchBarFullScreen: BehaviorRelay<Bool> = .init(value: true)
    let filterText: BehaviorRelay<String> = .init(value: "")
    let filterResults: BehaviorRelay<[Tweet]> = .init(value: [])
    
    let streamEnabled: BehaviorRelay<Bool> = .init(value: false)
    
    override func didLoad() {
        super.didLoad()
        
        filterResults
            .map { $0.count == 0 }
            .bind(to: searchBarFullScreen)
            .disposed(by: disposeBag)
        
        filterText
            .filter { $0.count > 3 }
            .debounce(.milliseconds(1300), scheduler: MainScheduler.instance)
            .flatMapLatest(doFilter)
            .map { _ in return true }
            .asDriver(onErrorJustReturn: false)
            .asObservable()
            .bind(to: streamEnabled)
            .disposed(by: disposeBag)
        
        streamEnabled
            .bind(onNext: handleStreamState)
            .disposed(by: disposeBag)
        
    }
    
    func handleStreamState(_ enabled: Bool) {
        
    }
    
    func doFilter(_ text: String) -> Observable<RulesData> {
        dependencies.apiRulesService?.reset(rules: [
            .init(value: text, tag: nil, id: nil)
        ]) ?? Observable.error(DIError.dependecyLost)
    }
    
}
