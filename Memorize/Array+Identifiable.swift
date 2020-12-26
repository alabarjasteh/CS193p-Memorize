//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Amirala on 9/1/1399 AP.
//  Copyright © 1399 AP Amirala. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        for i in 0..<self.count {
            if self[i].id == matching.id {
                return i
            }
        }
        return nil
    }
}
