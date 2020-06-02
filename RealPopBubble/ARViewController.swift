//
//  ViewController.swift
//  RealPopBubble
//
//  Created by Nikita Sergeev on 24/5/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import SwiftUI
import UIKit
import SceneKit
import ARKit

struct ARView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<ARView>) -> ARViewController {
        return ARViewController()
    }
    
    func updateUIViewController(_ uiViewController: ARViewController, context: UIViewControllerRepresentableContext<ARView>) {
        
    }
}

class ARViewController: UIViewController, ARSCNViewDelegate {
    override func loadView() {
        super.loadView()
        view = ARSCNView()
    }
    
    var sceneView: ARSCNView! = nil
    var rootNode: SCNNode!
    var originNode: SCNNode!
    var lastUpdateTime: TimeInterval = 0
    var gameLength: Double = 0.0
    var bubbleArray = [Bubble]()
    var bubble = Bubble(radius: 0.01)
    var maxBubbleNumber:Int = 100
    var bubbleExistsTime: TimeInterval = 0
    
    var didSetOrigin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView = self.view as? ARSCNView
        sceneView.delegate = self
        
        let scene = SCNScene()
        sceneView.scene = scene

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.antialiasingMode = .multisampling4X

        rootNode = sceneView.scene.rootNode
        
        // Setting up the origin
        originNode = SCNNode()
        rootNode.addChildNode(originNode)

        // 4 different constructors as you wish
//        let bubble1 = Bubble(radius: 0.01)
//        let bubble2 = Bubble(radius: 0.01, color: .pink)
//        let bubble3 = Bubble(radius: 0.01, position: SCNVector3(0.1, 0.1, 0.1))
//        let bubble4 = Bubble(radius: 0.01, color: .black, position: SCNVector3(0.05, 0.05, 0.05))
        

//        originNode.addChildNode(bubble1)
//        originNode.addChildNode(bubble2)
//        originNode.addChildNode(bubble3)
//        originNode.addChildNode(bubble4)
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        //1. Check/set global timer (if timer == 0, stop game)
        //2. Check bubble death timers - remove all bubbles that have expired
        if (self.gameLength == 0) {
            self.gameLength = time + 60
        }
        // Game ends logic
        if time >= gameLength { sceneView.session.pause() }
        
        // create bubble
        let delta = time - self.lastUpdateTime
        self.bubbleExistsTime += delta
        
        if self.bubbleExistsTime > 1 {
            createBubbles(time: time)
            self.bubbleExistsTime = 0
        }
        
        self.lastUpdateTime = time
    }
    
    
    func createBubbles(time: Double) {
        print("\(bubbleArray.count)")
        // var numberToCreate = arc4random_uniform(UInt32(maxBubbleNumber - bubbleArray.count)) + 1
        var numberToCreate = 2
        while 0 < numberToCreate {
            bubble = Bubble(radius: 0.01, color: .pink)
            if bubble.startTime == 0.0 {
                bubble.startTime = time
            }
            originNode.addChildNode(bubble)
            bubbleArray += [bubble]
            numberToCreate -= 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
        #if DEBUG
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        #endif
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    #if DEBUG
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor
            else {
                return
        }
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        
        plane.materials.first?.diffuse.contents = Color.blue
        
        let planeNode = SCNNode(geometry: plane)
        
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2
        
        node.addChildNode(planeNode)
    }
    #endif
    
    #if DEBUG
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else {
                return
        }
         
//        let width = CGFloat(planeAnchor.extent.x)
//        let height = CGFloat(planeAnchor.extent.z)
        plane.width = 0.5
        plane.height = 0.5
         
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
    }
    #endif
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: sceneView)
        
        var hitTestOptions = [SCNHitTestOption: Any]()
        hitTestOptions[SCNHitTestOption.boundingBoxOnly] = true
        let hitResults: [SCNHitTestResult] = sceneView.hitTest(location, options: hitTestOptions)
        
        // function removes bubble from the parent
        if let hit = hitResults.first {

            if didSetOrigin {
                hit.node.removeFromParentNode()
                // REMOVE FROM THE BUBBLE ARRAY
            } else {
                let translation = hit.worldCoordinates
                let x = translation.x
                let y = translation.y
                let z = translation.z
                
                originNode.position = SCNVector3(x, y, z)
                
                // Once we set up the origin, we start bubble spawn
                didSetOrigin = true
            }
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print(error)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
