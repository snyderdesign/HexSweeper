//
//  Builder.swift
//  Hex-Sweep
//
//  Created by Robert Snyder on 9/7/16.
//  Copyright © 2016 Robert Snyder. All rights reserved.
//

import Foundation

protocol Builder {
	func generate(_ width: Int) -> [Int]
}
