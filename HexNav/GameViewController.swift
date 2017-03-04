//
//  GameViewController.swift
//  Hex-Sweep
//
//  Created by Robert Snyder on 7/25/16.
//  Copyright © 2016 Robert Snyder. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {
	
	@IBOutlet var hexScene: SKView!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		print("LoadedGameView")
		buildScene()
		
    }  // end of viewdidload()
	
	func buildScene(){
		let scene = GameScene(size: view.bounds.size)
		let skView = view as! SKView
		skView.showsFPS = false
		skView.showsNodeCount = false
		skView.ignoresSiblingOrder = true
		scene.scaleMode = .resizeFill
		skView.presentScene(scene)
	}

    override var shouldAutorotate : Bool {
        return false
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
	

}
