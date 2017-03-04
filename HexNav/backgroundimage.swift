//
//  backgroundimage.swift
//  Hex-Sweep
//
//  Created by Robert Snyder on 11/14/16.
//  Copyright © 2016 Robert Snyder. All rights reserved.
//

import Foundation
import SpriteKit

class BackgroundImage : SKSpriteNode {
	
	init() {
		let texture: SKTexture = SKTexture(imageNamed: "background")
		super.init(texture: texture, color: UIColor(white: 1, alpha: 1), size: CGSize(width: 240, height: 52))
		self.isHidden = false
		self.zPosition = -1.0
		self.position = CGPoint(x: 200, y: 150)
	}
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
