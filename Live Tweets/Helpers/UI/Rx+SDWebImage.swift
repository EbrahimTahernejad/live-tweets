//
//  Rx+SDWebImage.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/10/1401 AP.
//

import UIKit
import RxCocoa
import RxSwift


extension Reactive where Base: UIImageView {
    
    /// Bindable sink for `sd_setImage` function.
    public var reactiveImageUrl: Binder<URL?> {
        return Binder(base) { imageView, image in
            DispatchQueue.main.async {
                imageView.sd_setImage(with: image, completed: nil)
            }
        }
    }
}

