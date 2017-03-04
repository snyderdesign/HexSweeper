//
//  PlantMines.swift
//  Hex-Sweep
//
//  Created by Robert Snyder on 9/7/16.
//  Copyright © 2016 Robert Snyder. All rights reserved.
//

import Foundation


public func plantMines(_ width: Int) -> [Int] {
	var theArray: [Int] = []
	let length = ((width)*(width))
	var mines = Int(floor(Double(length/5)+1))
	for _ in 1...length {
		if mines > 0 {
			theArray.append(8) //fatal error here (fixed)
			mines -= 1
		} else {
			theArray.append(0)
		}
	}
	theArray = shuffle(theArray)
	return theArray
} //end of generate


func shuffle(_ anArray: [Int]) -> [Int]{
	var thisArray = anArray
	let totalTiles = thisArray.count
	for i in 1...totalTiles {
		let newIndex = Int(arc4random_uniform(UInt32(totalTiles-1))+1)
		let tempValue = thisArray[i-1]
		thisArray[i-1] = thisArray[newIndex-1] //fatal error (fixed)
		thisArray[newIndex-1] = tempValue
	}
	return thisArray
} // end of shuffle
