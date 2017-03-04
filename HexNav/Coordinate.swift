//
//  Coordinate.swift
//  Hex-Sweep
//
//  Created by Robert Snyder on 7/25/16.
//  Copyright © 2016 Robert Snyder. All rights reserved.
//

import Foundation

class Coordinate {
    let x: Int
    let y: Int
	
    var hashValue: Int {
        return x ^ y
    }
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    init(x: Int, z: Int) {
        self.x = x
        self.y = -(x+z)
    }
    init(y: Int, z: Int) {
        self.y = y
        self.x = -(y+z)
    }
	
//	because there are two layers of hexes, each row requires a different check
//	odd(+1,0)(+1,+1)(0, -1)(0,+1)(-1,0)(-1,+1)
//	even(+1,-1)(+1,0)(0,-1)(0,+1)(-1,-1)(-1,0)
	
    func neighbors() -> [Coordinate] {
		var checks: [Coordinate] = []
		if (self.y)%2 == 0 {
			print("even") //even(+1,-1)(+1,0)(0,-1)(0,+1)(-1,-1)(-1,0)
			checks = [
				Coordinate(x: self.x-1, y: self.y+1),
				Coordinate(x: self.x, y: self.y+1),
				Coordinate(x: self.x-1, y: self.y),
				Coordinate(x: self.x+1, y: self.y),
				Coordinate(x: self.x-1, y: self.y-1),
				Coordinate(x: self.x, y: self.y-1)
			]
		} else {
			print("odd") //	odd(+1,0)(+1,+1)(0, -1)(0,+1)(-1,0)(-1,+1)
			checks = [
				Coordinate(x: self.x, y: self.y+1),
				Coordinate(x: self.x+1, y: self.y+1),
				Coordinate(x: self.x-1, y: self.y),
				Coordinate(x: self.x+1, y: self.y),
				Coordinate(x: self.x, y: self.y-1),
				Coordinate(x: self.x+1, y: self.y-1)
			]
		}
		return checks
    }
}

extension Coordinate: Hashable {}

func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}
