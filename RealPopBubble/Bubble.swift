//
//  Bubble.swift
//  RealPopBubble
//
//  Created by Nikita Sergeev on 31/5/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import SceneKit
import ARKit

enum BubbleColor {
    case red    // 40% spawn chance
    case pink   // 30%
    case green  // 15%
    case blue   // 10%
    case black  //  5%
}

class Bubble: SCNNode {
    var gamePoints: Int!
    var startTime: TimeInterval = 0.0
    var color: BubbleColor!
    
    let TRANSPARENCY: CGFloat = 0.7
    
    // Init without color, without position
    init(radius: CGFloat) {
        super.init()
        
        let radius = randRadius();
        let sphere = SCNSphere(radius: radius)
        
        self.color = randBubbleColor()
        
        setMaterial(geometry: sphere, color: self.color)

        self.geometry = sphere
        self.position = SCNVector3(0,0,0)
        self.move(radius: radius)
    }
    
    // Init without color, with position
    init(radius: CGFloat, position: SCNVector3) {
        super.init()
        
        let radius = randRadius();
        let sphere = SCNSphere(radius: radius)
        
        self.color = randBubbleColor()
        
        setMaterial(geometry: sphere, color: self.color)

        self.geometry = sphere
        self.position = position
        self.move(radius: radius)
    }
    
    // Init with color, without position
    init(radius: CGFloat, color: BubbleColor) {
        super.init()
        
        let radius = randRadius();
        let sphere = SCNSphere(radius: radius)
        
        self.color = color
        
        setMaterial(geometry: sphere, color: color)

        self.geometry = sphere
        self.position = SCNVector3(0,0,0)
        self.move(radius: radius)
    }
    
    // Init with color, with position
    init(radius: CGFloat, color: BubbleColor, position: SCNVector3) {
        super.init()
        
        let radius = randRadius();
        let sphere = SCNSphere(radius: radius)
        
        self.color = color
        
        setMaterial(geometry: sphere, color: color)
        
        sphere.firstMaterial?.transparency = 0.5

        self.geometry = sphere
        self.position = position
        self.move(radius: radius)
    }
    
    func setBubbleColorAndPoints(color: BubbleColor) -> UIColor{
        switch color {
        case .red:
            self.gamePoints = 1
            return UIColor.red
        case .pink:
            self.gamePoints = 2
            return UIColor.systemPink
        case .green:
            self.gamePoints = 5
            return UIColor.green
        case .blue:
            self.gamePoints = 8
            return UIColor.blue
        case .black:
            self.gamePoints = 10
            return UIColor.black
        }
    }
    
    func setMaterial(geometry: SCNGeometry, color: BubbleColor) {
        geometry.firstMaterial?.diffuse.contents = self.setBubbleColorAndPoints(color: color)
        geometry.firstMaterial?.shininess = 75
        geometry.firstMaterial?.transparencyMode = .dualLayer
        geometry.firstMaterial?.isDoubleSided = true
        geometry.firstMaterial?.lightingModel = .blinn
        geometry.firstMaterial?.fresnelExponent = 1.5
        geometry.firstMaterial?.specular.contents = UIColor(white: 0.6, alpha: 1.0)
        geometry.firstMaterial?.transparency = TRANSPARENCY
    }
    
    func setPosition(position: SCNVector3) {
        self.position = position
    }
    
    func randBubbleColor() -> BubbleColor {
        // Function randomises colors
        // see BubbleColor's comments
        let chance = Int.random(in: 0...19)
        
        switch chance {
        case 0..<8:
            return .red
        case 8..<14:
            return .pink
        case 14..<17:
            return .green
        case 17..<19:
            return .blue
        case 19:
            return .black
        default: //
            #if DEBUG
            print("The chance color: \(chance) is out or the range")
            #endif
            return .red
        }
    }
    
    func move(radius: CGFloat){
         let moveUp = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: Double(radius) * 100 * 5)

         moveUp.timingMode = .easeInEaseOut;
         let moveSequence = SCNAction.sequence([moveUp])
         self.runAction(moveSequence)
        
//         SCNAction.customAction(duration: Double(radius) * 100 * 0.5) { (node, elapsedTime) in
//          self.removeFromParentNode()
//         }
    }
    
    // make random sphere radius
    func randRadius() -> CGFloat {
        return CGFloat.random(in: 0.03...0.06)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
