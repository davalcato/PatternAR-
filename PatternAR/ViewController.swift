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
        
        var cards: [Entity] = []
        for _ in 1...4 {
            let box = MeshResource.generateBox(width: 0.04, height: 0.002, depth: 0.04)
            let metalMaterial = SimpleMaterial(color: .gray, isMetallic: true)
            let model = ModelEntity(mesh: box, materials: [metalMaterial])
            
            // Create the ability to press on the model
            model.generateCollisionShapes(recursive: true)
            
            // Cards array get append each time we iterate thru the loop
            cards.append(model)
        }
    }
}
