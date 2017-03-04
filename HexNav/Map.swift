//
//  Map.swift
//  Hex-Sweep
//
//  Created by Robert Snyder on 7/26/16.
//  Copyright © 2016 Robert Snyder. All rights reserved.
//

import UIKit

import Foundation
import SpriteKit


class Map {
	let radius: Int
	var tiles = Dictionary<Coordinate, Tile>()
	var offset: CGPoint = CGPoint(x: 0, y: 0)
	var height: CGFloat = 32
	var bricks: Int = 0
	var terrain: Int = 1
	var playable: Bool = true
	var themines: Int
	let winloss = Victory()
	let newGame = CustomButton()
	var newmap = true
	var framesize: CGSize
	var score: Int?
	var delegate: ScoreDelegate?
	
	init(radius: Int, terrainGenerator: TerrainGenerator, framesize: CGSize) {
		self.radius = radius
		//alternate map construction:---------------------------
		self.framesize = framesize
		let minesArray: [Int] = plantMines(radius)
		let thelength = ((radius)*(radius))
		themines = Int(floor(Double(thelength/5)+1))



		
//		scoreLabel = SKLabelNode(fontNamed: "Avenir-Heavy")
		var mineRunner: Int = 0
		for yIndex in 0...radius-1 {
			for xIndex in 0...radius-1 {
				let coordinate = Coordinate(x: xIndex, y: yIndex)
				terrain = minesArray[mineRunner]
				if mineRunner <= (minesArray.count-2) {
					mineRunner += 1
				}

				let tile = Tile(coordinate: coordinate, map: self, type: terrain)
				self.tiles[coordinate] = tile
			}
		}
		//end of alternate map construction---------------------
		for yIndex in 0...radius-1 {
			//this part declares the type by caling the neighbors through minecount
			for xIndex in 0...radius-1 {
				let coordinate = Coordinate(x: xIndex, y: yIndex)
				let theTile = self.tiles[coordinate]
				if theTile!.type == 8 {
					//nothing happening here.
				} else {
					theTile!.type = countMines(theTile!)
					if theTile!.active == false {
						theTile!.name = String(8)
					} else {
						theTile!.name = String(theTile!.type)
					}
				}
			} // end of xIndex loop
		}// end of spot checking
		newGame.position = CGPoint(x: (self.framesize.width*0.5), y: (self.framesize.height*0.22))
	} //end of init
	

	
	func countMines(_ thisTile: Tile) -> Int {
		print("reset score below")
		delegate?.resetScore()
		print("reset score above")
		var mineCount = 0
		let neighborArray = neighbors(thisTile.coordinate)
		for i in neighborArray {
			if i.type == 8 {
				mineCount += 1
			}
		}
		return mineCount
	} //end countMines
	
	func checkwinner(){
		print("delegate \(delegate)")
		print(themines)
		var tempvar = true
		for yIndex in 0...radius-1 {
			for xIndex in 0...radius-1 {
				let coordinate = Coordinate(x: xIndex, y: yIndex)
				let theTile = self.tiles[coordinate]
				if (theTile!.active == false && theTile!.type != 8) {
					print(coordinate.x)
					print("falsebreak")
					tempvar = false
					break
				} else if (theTile!.type == 8 && theTile?.active == true){
					print(coordinate.x)
					print("falsebreak")
					tempvar = false
					break
				} else {
				}
			} // end of xIndex loop
			if tempvar == false {
				break
			}
		}// end of spot checking
		if tempvar == true {
			// winner
			reveal(1)
			expose()

		}
	} //end of winner()
	
	func loser(){ //loser
		reveal(2)
		expose()

	} //end of loser()
	
	func reveal(_ count: Int) {
		// Send Information Back to Delegate
		winloss.isHidden = false
//		winloss.position = CGPoint(x: 200, y: 520)
		winloss.anchorPoint = CGPoint(x: 0, y: 1)
		winloss.position = CGPoint(x: 0, y: (self.framesize.height-(self.framesize.width*0.65)*0.39))
		winloss.size = CGSize(width: self.framesize.width, height: self.framesize.height*0.12)
		if (count == 1) {
			winloss.texture = SKTexture(imageNamed: "won")
			winloss.name = "won"
			
			//data start-----------
			
			let defaults = UserDefaults.standard
			score = defaults.integer(forKey: "totalWins")
			score = score! + 1
			defaults.setValue(score, forKey: "totalWins")
			
			defaults.synchronize()
			print("Win condition stuff--------------------------")
			print(defaults.integer(forKey: "totalWins"))
			print(score!)
			print("Win condition stuff ends---------------------")
			
			//data end -------------
			
		} else if (count == 2) {
			winloss.texture = SKTexture(imageNamed: "lost")
			winloss.name = "lost"
		}
	}
	
	func expose() {
		playable = false
		for yIndex in 0...radius-1 {
			for xIndex in 0...radius-1 {
				let coordinate = Coordinate(x: xIndex, y: yIndex)
				let theTile = self.tiles[coordinate]
				if theTile?.type == 8 && theTile?.flagged == false {
					theTile?.active = true
					if (winloss.name == "lost") {
						theTile?.texture = SKTexture(imageNamed: String(theTile!.type))
					} else if (winloss.name == "won") {
						print("This is a bomb tile that should be winbomb")
						theTile?.texture = SKTexture(imageNamed: "winbomb")
					}

				} else if theTile?.type == 8 && theTile?.flagged == true {
					theTile?.active = true
					theTile?.texture = SKTexture(imageNamed: "falseflag")
				} else if theTile?.type != 8 && theTile?.flagged == true {
					theTile?.active = true
					theTile?.texture = SKTexture(imageNamed: "emptyflag")
				}
				
				
			} // end of xIndex loop
		}// end of spot checking
	}
	
	func tile(_ coordinate: Coordinate) -> Tile? {
		return tiles[coordinate]
	}
	
	//this is a function that returns the neighbors of this cell if called... it is amazing and you're welcome.
	func neighbors(_ coordinate: Coordinate) -> [Tile] {
		var neighbors: [Tile] = []
		for neighbor in coordinate.neighbors() {
			let tile:Tile? = self.tile(neighbor)
			if let tile = tile {
				neighbors.append(tile)
			}
		}
		return neighbors
	}

	func camera(_ offset: CGPoint, height: CGFloat) {
		if(self.height == height && self.offset == offset) {
			
		} else {
			self.offset = offset
			self.height = height
			for (_, tile) in self.tiles {
				tile.camera(offset, height: height)
			}
		}
	}
}
