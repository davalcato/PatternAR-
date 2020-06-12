//
//  ViewController.swift
//  PatternAR
//
//  Created by Daval Cato on 6/12/20.
//  Copyright © 2020 Daval Cato. All rights reserved.
//

import UIKit
import RealityKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let anchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.2, 0.2])
        
        arView.scene.addAnchor(anchor)
        
        
    }
}
