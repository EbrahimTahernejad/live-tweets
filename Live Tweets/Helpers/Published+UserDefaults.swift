//
//  Published+UserDefaults.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/2/1401 AP.
//

import Foundation
import Combine


private var userDefaultsCancellables = [AnyCancellable]()


extension Published where Value: RawRepresentable, Value.RawValue == String {
    init(wrappedValue defaultValue: Value, key: String) {
        let value = UserDefaults.standard.string(forKey: key) ?? defaultValue.rawValue
        self.init(wrappedValue: Value.init(rawValue: value) ?? defaultValue)
        userDefaultsCancellables.append(
            projectedValue.sink { val in
                UserDefaults.standard.set(val.rawValue, forKey: key)
            }
        )
    }
}

extension Published where Value == Optional<String> {
    init(wrappedValue defaultValue: Optional<String>, key: String) {
        let value = UserDefaults.standard.string(forKey: key) ?? defaultValue
        self.init(wrappedValue: value)
        userDefaultsCancellables.append(
            projectedValue.sink { val in
                UserDefaults.standard.set(val, forKey: key)
            }
        )
    }
}

extension Published where Value == Bool {
    init(wrappedValue defaultValue: Bool, key: String) {
        let value = UserDefaults.standard.dictionaryRepresentation().keys.contains(key) ? UserDefaults.standard.bool(forKey: key) : defaultValue
        self.init(wrappedValue: value)
        userDefaultsCancellables.append(
            projectedValue.sink { val in
                UserDefaults.standard.set(val, forKey: key)
            }
        )
    }
}
