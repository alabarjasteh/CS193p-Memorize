//
//  Data2String.swift
//  Memorize
//
//  Created by Amirala on 10/6/1399 AP.
//  Copyright © 1399 AP Amirala. All rights reserved.
//

import Foundation

extension Data {
    // just a simple converter from a Data to a String
    var utf8: String? { String(data: self, encoding: .utf8 ) }
}
