//
//  Tile.swift
//  Hex-Sweep
//
//  Created by Robert Snyder on 7/25/16.
//  Copyright © 2016 Robert Snyder. All rights reserved.
//

import Foundation
import SpriteKit
//import UIKit
import AudioToolbox

class Tile : SKSpriteNode {
	var height: CGFloat = 200
	var width: CGFloat = 200
	let coordinate: Coordinate
	let map: Map
	var type: Int
	var flagged: Bool = false

	var active: Bool
	
	init(coordinate: Coordinate, map: Map, type: Int) {
		self.coordinate = coordinate
		self.map = map
		self.type = type
		self.active = false

		let texture: SKTexture = SKTexture(imageNamed: "grass")
		super.init(texture: texture, color: UIColor(white: 1, alpha: 1), size: CGSize(width: 83, height: 96))
		self.name = String(type)
		if map.framesize.height > map.framesize.width {
			self.width = (((map.framesize.width)*0.85)/(CGFloat(map.radius)))
			self.height = ((self.width*2.0)/(sqrt(3.0)))
		} else {
			self.height = (((map.framesize.height)*0.85)/(CGFloat(map.radius)))
			self.width = (self.height*(sqrt(3.0)/2.0))
		}
		self.size = CGSize(width: width, height: height)
	}

	required init(coder aDecoder: NSCoder) {
	fatalError("init(coder:) has not been implemented")
	}

	func mapLocation() -> CGPoint {
		let x: CGFloat = width*CGFloat(coordinate.x)+((width/CGFloat(2))*CGFloat(coordinate.y%2))
		let y: CGFloat = (height * CGFloat(0.75))*CGFloat(coordinate.y)
		return CGPoint(x:x,y:y)
	}

	
	func camera(_ offset: CGPoint, height: CGFloat) {
		//the value of the offset if the coordinates of the center of the screen
		let offsetX: CGFloat = mapLocation().x + (offset.x-(self.width*4.20)) //adjustments based on 8 radius
		let offsetY: CGFloat = mapLocation().y + (offset.y-(self.height*2.75))  //adjustments based on 8 radius
		self.position = CGPoint(x: offsetX, y: offsetY)
		self.setScale(0.95)
	} //this is not rooted to the map's radius.  This must be changed if you want to add more maps.
	
	func flagit() {
		
		if map.playable == true {
			if (self.flagged == true) {
				self.flagged = false
				self.texture = SKTexture(imageNamed: "grass")
				AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
//				self.active = false
			} else if (self.flagged == false && self.active == false) {
				self.flagged = true
				self.texture = SKTexture(imageNamed: "flag")
//				self.active = true
				AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
			}
		}

	}
	func explore() {
		print("explore()")
		if map.playable == true {
		print("map.playble == true")
			if (self.active == false && self.flagged == false) {
				print("self.active == false")
				self.active = true
				self.texture = SKTexture(imageNamed: String(self.type))
				if self.type == 0 {
					expand(tile: self)
				} else if self.type == 8 {
					self.map.loser()
				}
				self.map.checkwinner()
			} else if self.active == true {
				
			}
		}
		
	}//end of explore()
	
	func expand(tile: Tile) {
		var toexpand: [Tile] = [tile]
		while (toexpand != []) {
			for flands in toexpand[0].neighbors() {
				if (flands.active == false && flands.type == 0) {
					toexpand.append(flands)
				}
				flands.active = true
				flands.texture = SKTexture(imageNamed: String(flands.type))
			}
			toexpand.remove(at: 0)
		}
	}

	func neighbors() -> [Tile] {
		var neighbors: [Tile] = []
		for coordinate in self.coordinate.neighbors() {
		  let tile:Tile? = map.tile(coordinate)
		  if let tile = tile {
			neighbors.append(tile)
		  }
		}
		return neighbors
	}
}
