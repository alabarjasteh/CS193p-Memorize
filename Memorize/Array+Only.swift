//
//  Array+Only.swift
//  Memorize
//
//  Created by Amirala on 9/1/1399 AP.
//  Copyright © 1399 AP Amirala. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
