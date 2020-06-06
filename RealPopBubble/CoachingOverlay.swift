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
    
    func stopCoachingOverlay() {
        DispatchQueue.main.async {
            self.coachingOverlay.delegate = nil
            self.coachingOverlay.setActive(false, animated: false)
            self.coachingOverlay.removeFromSuperview()
        }
    }
    
    func presentCoachingOverlay() {
        coachingOverlay.session = sceneView.session
        coachingOverlay.activatesAutomatically = false
        coachingOverlay.delegate = self
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.setActive(true, animated: true)
        
        coachingOverlay.center = sceneView.center
        sceneView.addSubview(coachingOverlay)
    }
}
