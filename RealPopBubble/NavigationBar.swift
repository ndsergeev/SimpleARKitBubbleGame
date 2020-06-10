//
//  NavigationBar.swift
//  RealPopBubble
//
//  Created by Nikita Sergeev on 9/6/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import SwiftUI

// Navigation bar hider
struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            // these two hide the navigation bar
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            // to make iPad view look same as iPhone view
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension View {
    func hiddenNavigationBarStyle() -> some View {
        ModifiedContent(content: self, modifier: HiddenNavigationBar())
    }
}
