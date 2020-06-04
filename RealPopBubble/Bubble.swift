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
    
    let TRANSPARENCY: CGFloat = 0.7
    
    // Init without color, without position
    init(radius: CGFloat) {
        super.init()
        
        let sphere = SCNSphere(radius: radius)
        
        sphere.firstMaterial?.diffuse.contents = setBubbleColorAndPoints(color: randBubbleColor())
        
        sphere.firstMaterial?.transparency = TRANSPARENCY

        self.geometry = sphere
        self.position = SCNVector3(0,0,0)
        self.move()
    }
    
    // Init without color, with position
    init(radius: CGFloat, position: SCNVector3) {
        super.init()
        
        let sphere = SCNSphere(radius: radius)
        
        sphere.firstMaterial?.diffuse.contents = setBubbleColorAndPoints(color: randBubbleColor())
        
        sphere.firstMaterial?.transparency = TRANSPARENCY

        self.geometry = sphere
        self.position = position
        self.move()
    }
    
    // Init with color, without position
    init(radius: CGFloat, color: BubbleColor) {
        super.init()
        
        let sphere = SCNSphere(radius: radius)
        
        sphere.firstMaterial?.diffuse.contents = setBubbleColorAndPoints(color: color)
        
        sphere.firstMaterial?.transparency = TRANSPARENCY

        self.geometry = sphere
        self.position = SCNVector3(0,0,0)
        self.move()
    }
    
    // Init with color, with position
    init(radius: CGFloat, color: BubbleColor, position: SCNVector3) {
        super.init()
        
        let sphere = SCNSphere(radius: radius)
        
        sphere.firstMaterial?.diffuse.contents = setBubbleColorAndPoints(color: color)
        
        sphere.firstMaterial?.transparency = TRANSPARENCY

        self.geometry = sphere
        self.position = position
        self.move()
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
            print("The chance color: \(chance) is out or the range")
            return .red
        }
    }
    
    func move(){
         let moveUp = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 24)
         moveUp.timingMode = .easeInEaseOut;
        
         let moveDown = SCNAction.moveBy(x: 0, y: -1, z: 0, duration: 1)
         moveDown.timingMode = .easeInEaseOut;
         
         let moveSequence = SCNAction.sequence([moveUp, moveDown])
         let moveLoop = SCNAction.repeatForever(moveSequence)
         
         self.runAction(moveLoop)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
