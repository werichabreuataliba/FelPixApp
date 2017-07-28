//
//  GameViewController.swift
//  FelPixApp
//
//  Created by Macbook on 09/03/17.
//  Copyright © 2017 Werich. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let height = bounds.size.height
        
        let scene = CenaJogo(size: CGSize(width: width, height: height))
        let skView = self.view as! SKView
        
        skView.showsNodeCount = false
        skView.showsPhysics = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
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

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
