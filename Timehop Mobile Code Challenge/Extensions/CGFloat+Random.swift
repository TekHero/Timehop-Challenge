//
//  CGFloat+Random.swift
//  Timehop Mobile Code Challenge
//
//  Created by Brian Lim on 3/31/21.
//

import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
