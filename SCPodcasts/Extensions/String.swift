//
//  String.swift
//  SCPodcasts
//
//  Created by Suman Chatterjee on 11/02/2019.
//  Copyright © 2019 Suman Chatterjee. All rights reserved.
//

import Foundation

extension String {
    func toSecureHTTPS() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
}
