//
//  ContentView.swift
//  RealPopBubble
//
//  Created by Nikita Sergeev on 31/5/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var data: DataModel
    
    var body: some View {
        InitialView()
            .background(Color.black)
            .foregroundColor(.white)
    }
}

struct InitialView: View {
    @EnvironmentObject var data: DataModel
    @State var selection : Int? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                VStack {
                    Text("NOW").font(.system(size: 84))
                    Text("REAL").font(.system(size: 84))
                    HStack {
                        Text("PoPit ").font(.system(size: 48))
                        Text("🎈").animation(Animation.interactiveSpring(response: 3, dampingFraction: 0.1, blendDuration: 1))
                        .font(.system(size: 60))
                    }
                }
                
                Spacer()
                
                NavigationLink(destination: GameplayView(), tag: 0, selection: self.$selection) {
                    Text("")
                }.hiddenNavigationBarStyle()
                
                Button(action: { self.selection = 0 }) {
                    Text("START")
                    .padding()
                }.font(.system(size: 24))
                .padding(Edge.Set.horizontal, 30)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(4.0)
                
                Spacer()
            }
        }.hiddenNavigationBarStyle()
    }
}

#if DEBUG

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
