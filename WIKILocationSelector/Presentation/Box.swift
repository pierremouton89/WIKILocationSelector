//
//  Box.swift
//  WIKILocationSelector
//
//  Created by Pierre Mouton on 23/06/2023.
//

import Foundation

final class Box<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.listener?(self.value)
            }
        }
    }
    init(_ value: T) {
        self.value = value
    }
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
