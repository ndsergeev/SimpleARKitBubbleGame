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

        // 4 different constructors as you wish
        let bubble1 = Bubble(radius: 0.01)
        let bubble2 = Bubble(radius: 0.01, color: .pink)
        let bubble3 = Bubble(radius: 0.01, position: SCNVector3(0.1, 0.1, 0.1))
        let bubble4 = Bubble(radius: 0.01, color: .black, position: SCNVector3(0.05, 0.05, 0.05))

        rootNode.addChildNode(bubble1)
        rootNode.addChildNode(bubble2)
        rootNode.addChildNode(bubble3)
        rootNode.addChildNode(bubble4)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: sceneView)
        
        var hitTestOptions = [SCNHitTestOption: Any]()
        hitTestOptions[SCNHitTestOption.boundingBoxOnly] = true
        let hitResults: [SCNHitTestResult] = sceneView.hitTest(location, options: hitTestOptions)
        
        // function removes bibble from parent
        if let hit = hitResults.first {
            hit.node.removeFromParentNode()
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
