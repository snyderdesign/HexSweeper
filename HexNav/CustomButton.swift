//
//  buttons.swift
//  Hex-Sweep
//
//  Created by Robert Snyder on 11/14/16.
//  Copyright © 2016 Robert Snyder. All rights reserved.
//

import Foundation
import SpriteKit

class CustomButton : SKSpriteNode {
	
	init() {
		let texture: SKTexture = SKTexture(imageNamed: "newgame")
		super.init(texture: texture, color: UIColor(white: 1, alpha: 1), size: CGSize(width: 240, height: 52))
		self.isHidden = false
		self.position = CGPoint(x: 200, y: 150)
		self.zPosition = 1.5
	}
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
