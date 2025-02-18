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
        
        self.data!.timer = 30
        
        self.data!.currentScore = 0

        self.data!.gameIsPaused = false
        self.data!.gameIsOver = false
        self.data!.didSetOrigin = false
        self.data!.surfaceIsScanned = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // main components
    var sceneView: ARSCNView! = nil
    var rootNode: SCNNode!
    var originNode: SCNNode!
    
    // origin based variables
    var planes = [SCNNode]()
    let coachingOverlay = ARCoachingOverlayView()
    
    var lastUpdateTime: TimeInterval = 0

    var bubbleExistsTime: TimeInterval = 0
    var previousBubbleColor: BubbleColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView = self.view as? ARSCNView
        sceneView.delegate = self
        
        let scene = SCNScene()
        sceneView.scene = scene

        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
        sceneView.antialiasingMode = .multisampling4X

        rootNode = sceneView.scene.rootNode
        
        // Setting up the origin
        originNode = Origin()
        originNode.isHidden = true
        rootNode.addChildNode(originNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        
        if lastUpdateTime == 0 {
            lastUpdateTime = time
        }
        
        let delta = time - lastUpdateTime
        
        if data!.didSetOrigin {
            updateTimer(delta: delta)
            
            // create bubble
            self.bubbleExistsTime += delta
            
            if self.bubbleExistsTime > 2 {
                spawnBubble()
                
                self.bubbleExistsTime = 0
            }
        }
        
        // Game is over
        if data!.timer < 0.0 {
            // ToDo:
            // This pause does not actually pauses the animation, etc
            // wait 60 seconds

            removeBubbles()
            zeroTimer()
            sceneView.session.pause()
            updateGameIsOver(val: true)
        }
        
        self.lastUpdateTime = time
    }
    
    func updateDidSetOrigin(val: Bool) {
        DispatchQueue.main.async {
            self.data!.didSetOrigin = val
        }
    }
    
    func updateGameIsOver(val: Bool) {
        DispatchQueue.main.async {
            self.data!.gameIsOver = val
        }
    }
    
    func updateTimer(delta: TimeInterval) {
        // need to run it asyncronically
        // so it updates UI without a delay
        DispatchQueue.main.async {
            self.data!.timer -= delta
        }
    }
    
    func zeroTimer() {
        DispatchQueue.main.async {
            self.data!.timer = 0
        }
    }
    
    func removeBubbles() {
        DispatchQueue.main.async {
            for bubble in self.originNode.childNodes {
                bubble.removeFromParentNode()
            }
        }
    }
    
    func spawnBubble() {
        let randNumber = Int.random(in: 1...5)
        for _ in 0...randNumber {
            // change the constructor when Michelle implements radius range
            let bubble = Bubble(position: randSpawnPos(origin: originNode.position))
            
            originNode.addChildNode(bubble)
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
//        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
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
        hitTestOptions[SCNHitTestOption.ignoreHiddenNodes] = true
        hitTestOptions[SCNHitTestOption.backFaceCulling] = true
        hitTestOptions[SCNHitTestOption.firstFoundOnly] = true
        hitTestOptions[SCNHitTestOption.ignoreLightArea] = true

        let hitResults: [SCNHitTestResult] = sceneView.hitTest(location, options: hitTestOptions)
        
        // function removes bubble from the parent
        if let hit = hitResults.first {

            if data!.didSetOrigin {
                if hit.node.isKind(of: Bubble.self) {
                    touchBubble(hit: hit)
                }
            } else {
                if !coachingOverlay.isActive {
                    let translation = hit.worldCoordinates
                    let x = translation.x
                    let y = translation.y
                    let z = translation.z
                    
                    originNode.position = SCNVector3(x, y, z)
                    originNode.isHidden = false
                    
                    // Once we set up the origin, we start bubble spawn
                    updateDidSetOrigin(val: true)
                    
                    for plane in planes {
                        plane.removeFromParentNode()
                    }
                    planes.removeAll()
                    
                    // reset scanning
                    sceneView.session.delegate = nil
                    sceneView.session.run(ARWorldTrackingConfiguration())
                    
                    // becuase when timer starts we need to init bubbles
                    // for the first time
                    spawnBubble()
                }
            }
        }
    }
    
    func touchBubble(hit: SCNHitTestResult) {
        // that is quite unsafe, but we have the only root and origin
        DispatchQueue.main.async {
            let bubble = hit.node as! Bubble
                             
            // Give points
            if bubble.color == self.previousBubbleColor {
                self.data!.currentScore += Int(((Double(bubble.gamePoints) * 1.5)).rounded())
            } else {
                self.data!.currentScore += Int(bubble.gamePoints)
            }
            self.previousBubbleColor = bubble.color

            // Uncomment if you add player profiles and their records
            // if self.data!.currentScore > self.data!.highestScore {
            //     self.data!.highestScore = self.data!.currentScore
            // }
            
            // Removals
            hit.node.removeFromParentNode()
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print(error)
    }
}
