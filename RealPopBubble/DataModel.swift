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
    static var shared = DataModel()
    
    @Published var highestScore: Int
    @Published var currentScore: Int

    @Published var timer: TimeInterval
    @Published var gameIsPaused: Bool
    @Published var gameIsOver: Bool

    init() {
        highestScore = 0
        currentScore = 0

        timer = 60

        gameIsPaused = false
        gameIsOver = false
    }
}
