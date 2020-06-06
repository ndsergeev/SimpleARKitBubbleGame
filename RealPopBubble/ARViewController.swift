//
//  ViewController.swift
//  RealPopBubble
//
//  Created by Nikita Sergeev on 24/5/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {
    override func loadView() {
        super.loadView()
        view = ARSCNView()
    }
    
    var data: DataModel?
    init(data: DataModel) {
        super.init(nibName: nil, bundle: nil)
        self.data = data
        // you can reinit all fields here
        self.data!.timer = 60
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var sceneView: ARSCNView! = nil
    var rootNode: SCNNode!
    var originNode: SCNNode!
    
    var lastUpdateTime: TimeInterval = 0

    var bubbles = [Bubble]()
    var bubbleExistsTime: TimeInterval = 0
    
    var planes = [SCNNode]()
    
    var didSetOrigin: Bool = false
    
    let coachingOverlay = ARCoachingOverlayView()
    
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
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        if lastUpdateTime == 0 {
            lastUpdateTime = time
        }
        
        let delta = time - lastUpdateTime
        
        if didSetOrigin {
            updateTimer(delta: delta)
            
            // create bubble
            self.bubbleExistsTime += delta
            
            if self.bubbleExistsTime > 2 {
                spawnBubble(time: time)
                
                self.bubbleExistsTime = 0
            }
        }
        
        // Game is over
        if data!.timer < 0.0 {
            // ToDo:
            // This pause does not actually pauses the animation, etc
            // wait 60 seconds
            sceneView.session.pause()
            updateGameIsOver(val: true)
        }
        
        self.lastUpdateTime = time
    }
    
    func updateGameIsOver(val: Bool) {
        DispatchQueue.main.async {
            self.data?.gameIsOver = val
        }
    }
    
    func updateTimer(delta: TimeInterval) {
        // need to run it asyncronically
        // so it updates UI without a delay
        DispatchQueue.main.async {
            self.data?.timer -= delta
        }
    }
    
    func spawnBubble(time: Double) {
        for _ in 0...2 {
            let bubble = Bubble(radius: 0.025, position: randSpawnPos(origin: originNode.position))
            bubble.startTime = time
            
            originNode.addChildNode(bubble)
            bubbles.append(bubble)
        }
    }
    
    // Move this function to bubble and make it work
    func randSpawnPos(origin: SCNVector3) -> SCNVector3 {
        let x = CGFloat.random(in: -0.5...0.5)
        let y: CGFloat = 0.0
        let z = CGFloat.random(in: -0.5...0.5)
        
        return SCNVector3(x,y,z)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: sceneView)
        
        var hitTestOptions = [SCNHitTestOption: Any]()
        hitTestOptions[SCNHitTestOption.boundingBoxOnly] = true
        let hitResults: [SCNHitTestResult] = sceneView.hitTest(location, options: hitTestOptions)
        
        // function removes bubble from the parent
        if let hit = hitResults.first {

            if didSetOrigin {
                // Give points
                data!.currentScore += 10
                if data!.currentScore > data!.highestScore {
                    data!.highestScore = data!.currentScore
                }
                // Removals
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
                
                for plane in planes {
                    plane.removeFromParentNode()
                }
                planes.removeAll()
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {

    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print(error)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        presentCoachingOverlay()
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
