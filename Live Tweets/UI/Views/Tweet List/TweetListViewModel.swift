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
        [.router, .apiRulesService, .apiStreamService]
    }
    
    let searchBarFullScreen: BehaviorRelay<Bool> = .init(value: true)
    let filterText: BehaviorRelay<String> = .init(value: "")
    let filterResults: BehaviorRelay<[Tweet]> = .init(value: [])
    let streamOutput: PublishRelay<[Tweet]> = .init()
    
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
            .bind(onNext: handleStreamState)
            .disposed(by: disposeBag)
        
        streamOutput
            .map { [weak self] out in
                return out + (self?.filterResults.value ?? [])
            }
            .bind(to: filterResults)
            .disposed(by: disposeBag)
        
        dependencies.apiStreamService?.output.bind { [weak self] output in
            switch output {
            case .connecting:
                self?.streamEnabled.accept(true)
                print("API Connecting")
            case .disconnected:
                self?.streamEnabled.accept(false)
                print("API Disconnected")
            case .data(let data):
                self?.streamOutput.accept(data.data.map({ d in
                    return Tweet(data: [d], includes: data.includes)
                }))
            }
        }.disposed(by: disposeBag)
        
    }
    
    private func handleStreamState(_ enabled: Bool) {
        if enabled {
            dependencies.apiStreamService?.connect()
        } else {
            dependencies.apiStreamService?.disconnect()
        }
    }
    
    func disconnect() {
        streamEnabled.accept(false)
    }
    
    private func doFilter(_ text: String) -> Observable<RulesData> {
        dependencies.apiRulesService?.reset(rules: [
            .init(value: text, tag: nil, id: nil)
        ]) ?? Observable.error(DIError.dependecyLost)
    }
    
}
