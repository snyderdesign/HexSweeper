//
//  victory.swift
//  Hex-Sweep
//
//  Created by Robert Snyder on 11/11/16.
//  Copyright © 2016 Robert Snyder. All rights reserved.
//

import Foundation
import SpriteKit

class Victory : SKSpriteNode {
	var height: CGFloat = 8
	var width: CGFloat { return (height*(sqrt(3.0)/2.0)) }
	
	init() {
		let texture: SKTexture = SKTexture(imageNamed: "lost")
		super.init(texture: texture, color: UIColor(white: 1, alpha: 1), size: CGSize(width: 120, height: 96))
		self.isHidden = true
		self.zPosition = 4
	}
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
