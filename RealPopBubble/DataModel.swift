//
//  GSettings.swift
//  RealPopBubble
//
//  Created by Nikita Sergeev on 2/6/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import SwiftUI

final class DataModel: ObservableObject {
    // Observable Singleton
    static let shared = DataModel()
    
    @Published var currentScore: Int

    @Published var timer: TimeInterval
    @Published var gameIsPaused: Bool
    @Published var gameIsOver: Bool
    @Published var didSetOrigin: Bool
    @Published var surfaceIsScanned: Bool

    private init() {
        currentScore = 0

        timer = 60

        gameIsPaused = false
        gameIsOver = false
        
        didSetOrigin = false
        surfaceIsScanned = false
    }
}
