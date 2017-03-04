//
//  GameScene.swift
//  Hex-Sweep
//
//  Created by Robert Snyder on 7/25/16.
//  Copyright © 2016 Robert Snyder. All rights reserved.
//

import UIKit
import SpriteKit


class GameScene: SKScene, ScoreDelegate {
	var tileHeight: CGFloat = 30
	var xOffset: CGFloat = 0
	var yOffset: CGFloat = 0
	var midPoint: CGPoint?
	var realRadius: CGFloat = 9
	var framesize: CGSize?
	let backgroundimage = BackgroundImage()
	var timer = Timer()
	var currentTile: Tile?
	var scoreLabel: SKLabelNode!
	var score: Int?
	var thelogo: SKSpriteNode!
//	let aScene: SKScene?

	var map = Map(radius: 9, terrainGenerator: RandomTerrainGenerator(), framesize: CGSize(width: 1, height: 1))

	override func didMove(to view: SKView) {
		timer.invalidate()
		framesize = self.frame.size
		tileHeight = self.frame.midY/(realRadius)
		self.backgroundColor = UIColor.cyan
		backgroundimage.size = self.frame.size
		backgroundimage.position = CGPoint(x: (self.frame.size.width)/2, y: (frame.size.height)/2)
		midPoint = CGPoint(x:(self.frame.midX), y:(self.frame.midY))
		refresh(tileHeight, midPoint: midPoint!)
		newMap()
	} //end of override func
	
	func newMap() {
		
		self.removeAllChildren()
		
		map = Map(radius: 9, terrainGenerator: RandomTerrainGenerator(), framesize: framesize!)
		refresh(tileHeight, midPoint: midPoint!)
		self.addChild(map.newGame)
		self.addChild(backgroundimage)
		
		//score stuff
		let defaults = UserDefaults.standard
		score = defaults.integer(forKey: "totalWins")
		scoreLabel = SKLabelNode(fontNamed: "Avenir-Heavy")
		scoreLabel.text = "Total Wins: "+String(describing: score!)
		scoreLabel.horizontalAlignmentMode = .center
		scoreLabel.position = CGPoint(x: (self.frame.width*0.5), y: (self.frame.height*0.75))
		scoreLabel.zPosition = 3
		scoreLabel.fontColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 1)
		//end of score stuff
		
		self.addChild(scoreLabel)
		thelogo = SKSpriteNode(imageNamed: "logo")
//		thelogo.texture = SKTexture(imageNamed: "logo")
		thelogo.position = CGPoint(x: -(self.frame.width*0.009), y: (self.frame.height))
		thelogo.size = CGSize(width: (self.frame.width*0.65), height: ((self.frame.width*0.65)*0.43))
		thelogo.anchorPoint = CGPoint(x: 0, y: 1)
		thelogo.zPosition = 100
		self.addChild(thelogo)
	}
	
	func refresh(_ titleHeight: CGFloat, midPoint: CGPoint) {
		self.map.camera(midPoint, height: titleHeight)
		for (_, tile) in (map.tiles) {
			self.addChild(tile)
		}
		self.addChild(map.winloss)

	}
	
	func resetScore() {
		print("delegate worked")
	}
	
	override func update(_ currentTime: TimeInterval) {
		/* Called before each frame is rendered */
		// use this space to update the number of wins... move the wins label into the gamescene.
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

		guard let touch = touches.first else {
			return
		}
		let touchLocation = touch.location(in: self)
		let node = self.atPoint(touchLocation)
		let tile = node as? Tile
		let newgamebutton = node as? CustomButton
		if tile != nil {
			print(tile!.coordinate)
		} else if newgamebutton != nil {
			print(newgamebutton!.texture!)
		}
		currentTile = tile
		timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(flagNode), userInfo: nil, repeats: true)
		
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else {
			return
		}
		
		let touchLocation = touch.location(in: self)
		let node = self.atPoint(touchLocation)
		let tile = node as? Tile
		if tile != currentTile {
			timer.invalidate()
		}
	}
	
	func flagNode() {
		timer.invalidate()
		if (map.newmap == true) {
			
		} else if (map.newmap == false) {
			currentTile?.flagit()
			//SystemSoundID(kSystemSoundID_Vibrate)

		}
//		print("NEW MAP")
		print(timer.isValid)
	}
	
	
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		guard let touch = touches.first else {
			return
		}
		if (timer.isValid == true){
			let touchLocation = touch.location(in: self)
			let node = self.atPoint(touchLocation)
			let tile = node as? Tile
			let newgamebutton = node as? CustomButton
			if tile != nil {
				//tile checks
				if tile == currentTile {
					if map.newmap == true { //first touches
						var temptile = tile
						print("newmap")
						print(tile!.type)
						if tile?.type == 0 {
							
						} else {
							var temp = 1
							let coords = tile?.coordinate
							print("before loop")
							while temp != 0 {
								newMap()
								temptile = map.tiles[coords!]
								if temptile?.type == 0 {
									temp = 0
								}
							}
							
						}
						temptile?.explore()
						map.newmap = false
						print("first touch")
					} else { // for the second or more touches
						tile!.explore()
					}
				}

				//end tile checks
			} else if newgamebutton != nil {
				//new game button
				newMap()
				//end of new game button
			}
		}

		timer.invalidate()
	}
	//end of touchesEnded
	
}
