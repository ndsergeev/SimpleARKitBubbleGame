//
//  CoachOverlay.swift
//  RealPopBubble
//
//  Created by Nikita Sergeev on 7/6/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import ARKit

extension ARViewController: ARCoachingOverlayViewDelegate, ARSessionDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        presentCoachingOverlay()
    }
    
//    func sessionWasInterrupted(_ session: ARSession) {
//        // Inform the user that the session has been interrupted, for example, by presenting an overlay
//        presentCoachingOverlay()
//    }
    
    func stopCoachingOverlay() {
        // deletes animated signifier from the view
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.data!.surfaceIsScanned = true
            self.coachingOverlay.delegate = nil
            self.coachingOverlay.setActive(false, animated: false)
            self.coachingOverlay.removeFromSuperview()
        }
    }
    
    func presentCoachingOverlay() {
        // overlays animated signifier over the view
        
        coachingOverlay.session = sceneView.session
        coachingOverlay.activatesAutomatically = false
        coachingOverlay.delegate = self
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.setActive(true, animated: true)
        
        coachingOverlay.center = sceneView.center
        sceneView.addSubview(coachingOverlay)
    }
}
