//
//  ViewController.swift
//  PatternAR
//
//  Created by Daval Cato on 6/12/20.
//  Copyright © 2020 Daval Cato. All rights reserved.
//

import UIKit
import RealityKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let anchor = AnchorEntity(plane: .horizontal, minimumBounds: [0.2, 0.2])
        
        arView.scene.addAnchor(anchor)
        
        var cards: [Entity] = []
        for _ in 1...16 {
            let box = MeshResource.generateBox(width: 0.04, height: 0.002, depth: 0.04)
            let metalMaterial = SimpleMaterial(color: .gray, isMetallic: true)
            let model = ModelEntity(mesh: box, materials: [metalMaterial])
            
            // Create the ability to press on the model
            model.generateCollisionShapes(recursive: true)
            
            // Cards array get append each time we iterate thru the loop
            cards.append(model)
        }
        
        // Position the cards with a for loop to get a sequence of pairs
        for (index, card) in cards.enumerated() {
            // create an X coordinance and using a Float as a dataType for the cards
            let x = Float(index % 4)
            let z = Float(index / 4)
            
            card.position = [x*0.1, 0, z*0.1]
            anchor.addChild(card)
        }
        
        // Create an occlusionbox here
        let boxSize: Float = 0.7
        let occlusionBoxMesh = MeshResource.generateBox(size: boxSize)
        
        // The occlusion material here
        let occlusionBox = ModelEntity(mesh: occlusionBoxMesh, materials: [OcclusionMaterial()])
        
        // This is where we position the occlusionBox
        occlusionBox.position.y = -boxSize/2
        
        anchor.addChild(occlusionBox)
        
        // Ensures that the load request is not deallocated until we no longer need it
        var cancellable: AnyCancellable? = nil
        
        cancellable = ModelEntity.loadModelAsync(named: "01")
            .append(ModelEntity.loadModelAsync(named: "02"))
            .append(ModelEntity.loadModelAsync(named: "03"))
            .append(ModelEntity.loadModelAsync(named: "04"))
            .append(ModelEntity.loadModelAsync(named: "05"))
            .append(ModelEntity.loadModelAsync(named: "06"))
            .append(ModelEntity.loadModelAsync(named: "07"))
            .append(ModelEntity.loadModelAsync(named: "08"))
            
        .collect()
        .sink(receiveCompletion: {error in
            print("Error: \(error)")
            cancellable?.cancel()
        }, receiveValue: { entities in
            var objects: [ModelEntity] = []
            // Scale down all entities here
            for entity in entities {
                entity.setScale(SIMD3<Float>(0.002, 0.002, 0.002), relativeTo: anchor)
                entity.generateCollisionShapes(recursive: true)
                // Here we clone each entity to create a pair of each models
                for _ in 1...2 {
                    objects.append(entity.clone(recursive: true))
                    
                }
                
            }
            // Here we shuffle the objects
            objects.shuffle()
            // Here we place the objects on the cards
            for (index, object) in objects.enumerated() {
                cards[index].addChild(object)
                // Placing the models below the cards
                cards[index].transform.rotation = simd_quatf(angle: .pi, axis: [1, 0, 0])
            }
            // Cancelling the activate here
            cancellable?.cancel()
            
        })
        
        
    }
    
    // Created an IBAction for the tap gesture
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        // Does the location where we tap have a card there
        let tapLocation = sender.location(in: arView)
        // Looking for the tap location point
        if let card = arView.entity(at: tapLocation) {
            // If the card is already turned around we want to flip the card
            if card.transform.rotation.angle == .pi {
                var flipDownTransform = card.transform
                // To make the rotation possible
                flipDownTransform.rotation = simd_quatf(angle: 0, axis: [1, 0, 0])
                card.move(to: flipDownTransform, relativeTo: card.parent, duration: 0.25, timingFunction: .easeInOut)
            }else{
                // Want to rotate the card by a 180 degress
                var flipUpTransform = card.transform
                flipUpTransform.rotation = simd_quatf(angle: .pi, axis: [1, 0, 0])
                card.move(to: flipUpTransform, relativeTo: card.parent, duration: 0.25, timingFunction: .easeInOut)
                
            }
            
        }
        
    }
    
}
