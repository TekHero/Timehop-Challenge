//
//  World.swift
//  Timehop Mobile Code Challenge
//
//  Created by Brian Lim on 3/25/21.
//

import Foundation

struct World {
    var api = SplashBaseService()
}

#if DEBUG
var Current = World()
#else
let Current = World()
#endif
