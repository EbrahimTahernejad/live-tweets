//
//  RxSwift+UserDefaults.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import Foundation
import RxSwift


final class UserDefaultsRelay<EType>: ObservableType {
    
    typealias Element = Optional<EType>
    
    private let _default: Element
    private let _key: String
    private let _subject: BehaviorSubject<Element>

    /// Accepts `event` and emits it to subscribers
    func accept(_ event: Element) {
        UserDefaults.standard.set(event, forKey: _key)
        self._subject.onNext(event ?? _default)
    }

    /// Current value of behavior subject
    var value: Element {
        // this try! is ok because subject can't error out or be disposed
        return try! self._subject.value()
    }

    /// Initializes behavior relay with initial value.
    init(key: String, default: Element = nil) {
        self._key = key
        self._default = `default`
        let value = UserDefaults.standard.object(forKey: key) as? Element
        self._subject = BehaviorSubject(value: value ?? `default`)
    }

    /// Subscribes observer
    func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == Element {
        return self._subject.subscribe(observer)
    }

    /// - returns: Canonical interface for push style sequence
    func asObservable() -> Observable<Element> {
        return self._subject.asObservable()
    }
    
}

