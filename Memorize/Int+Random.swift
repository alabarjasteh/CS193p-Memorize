//
//  Int+Random.swift
//  Memorize
//
//  Created by Amirala on 9/14/1399 AP.
//  Copyright © 1399 AP Amirala. All rights reserved.
//

import Foundation

extension Int {
    func random(startingFrom start: Int) -> Int {
        return Int.random(in: start...self)
    }
}
