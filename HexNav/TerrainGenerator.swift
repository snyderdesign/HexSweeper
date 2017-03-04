//
//  TerrainGenerator.swift
//  Hex-Sweep
//
//  Created by Robert Snyder on 7/25/16.
//  Copyright © 2016 Robert Snyder. All rights reserved.
//

import Foundation

protocol TerrainGenerator {
    func generate(_ coordinate: Coordinate) -> Int
}
