//
//  Debug.swift
//  RealPopBubble
//
//  Created by Nikita Sergeev on 5/6/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import ARKit

extension ARViewController {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // inits constructed horisontal planes and scales them
        
        guard let planeAnchor = anchor as? ARPlaneAnchor
            else {
                return
        }
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        
        plane.materials.first?.diffuse.contents = CGColor(srgbRed: 0, green: 0, blue: 1, alpha: 0.6)
        
        let planeNode = SCNNode(geometry: plane)
        
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2
        
        node.addChildNode(planeNode)
        planes.append(planeNode)
        
        if coachingOverlay.isActive {
            stopCoachingOverlay()
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // renders horisontal node planes
        
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else {
                return
        }
        
        plane.width = CGFloat(planeAnchor.extent.x)
        plane.height = CGFloat(planeAnchor.extent.z)
         
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
        
        if coachingOverlay.isActive {
            stopCoachingOverlay()
        }
    }
}
