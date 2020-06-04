//
//  ARKitView.swift
//  RealPopBubble
//
//  Created by Nikita Sergeev on 2/6/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import SwiftUI
import ARKit

struct ARView: UIViewControllerRepresentable {
    @EnvironmentObject var data: DataModel

    func makeUIViewController(context: UIViewControllerRepresentableContext<ARView>) -> ARViewController {
        return ARViewController(data: data)
    }

    func updateUIViewController(_ uiViewController: ARViewController, context: UIViewControllerRepresentableContext<ARView>) {}
}
