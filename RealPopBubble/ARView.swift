//
//  ARKitView.swift
//  RealPopBubble
//
//  Created by Nikita Sergeev on 2/6/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import SwiftUI
import ARKit

struct ARView: UIViewRepresentable {
    @EnvironmentObject var settings: GSettings
    
    class Coordinator: NSObject {
        var scene: ARSCNView?
        var settings: GSettings
        
        init(settings: GSettings) {
            self.settings = settings
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(settings: self.settings)
    }
    
    func makeUIView(context: Context) -> ARSCNView {
        let view = ARSCNView(frame: .zero)
        
        context.coordinator = 
        
        return
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        view.presentScene(context.coordinator.scene)
    }
}

struct GameView: UIViewRepresentable {
    @EnvironmentObject var prefs: Prefs

    class Coordinator: NSObject {
        var scene: SKScene?
        var prefs: Prefs

        init(prefs: Prefs) {
            self.prefs = prefs
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(prefs: self.prefs)
    }

    func makeUIView(context: Context) -> SKView {
        let view = SKView(frame: .zero)

        view.preferredFramesPerSecond = 60

        // These two lines to comment/uncomment
//        view.showsFPS = true
//        view.showsNodeCount = true

        let mainScene = SKGameScene(size: view.bounds.size, prefs: context.coordinator.prefs)

        mainScene.scaleMode = .resizeFill
        context.coordinator.scene = mainScene

        return view
    }

    func updateUIView(_ view: SKView, context: Context) {
        view.presentScene(context.coordinator.scene)
    }
}

//struct ARView: UIViewControllerRepresentable {
//    @EnvironmentObject var settings: GSettings
//
//
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<ARView>) -> ARViewController {
//        return ARViewController()
//    }
//
//    func updateUIViewController(_ uiViewController: ARViewController, context: UIViewControllerRepresentableContext<ARView>) {
//
//    }
//}
