//
//  Origin.swift
//  RealPopBubble
//
//  Created by Nikita Sergeev on 7/6/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import ARKit

class Origin: SCNNode {
    // origin, used as a parent of all bubbles
    
    init(height: CGFloat = 0.02, length: CGFloat = 0.02, width: CGFloat = 0.02) {
        super.init()
        
        let pyramid = SCNPyramid()
        
        pyramid.materials.first?.diffuse.contents = UIColor.darkGray
        

        pyramid.height = height
        pyramid.length = length
        pyramid.width = width
        
        self.geometry = pyramid
        self.position = SCNVector3(0,0,0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
