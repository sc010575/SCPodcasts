//
//  Observer.swift
//  SCPodcasts
//
//  Created by Suman Chatterjee on 28/09/2019.
//  Copyright © 2019 Suman Chatterjee. All rights reserved.
//

import Foundation

class Observer<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
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
