//
//  ContentView.swift
//  RealPopBubble
//
//  Created by Nikita Sergeev on 31/5/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ARView().edgesIgnoringSafeArea(.all)
        .overlay(ARKitBittomView())
    }
}

struct ARKitBittomView: View {
//    @EnvironmentObject var prefs: Prefs
    
    var body: some View {
        VStack {
            HStack {
                VStack {
//                    Text("Highest: \(self.prefs.highestScore)")
//                    Text("Current: \(self.prefs.lastScore)")
                    Text("Highest: 0")
                    Text("Current: 0")
                }

                Spacer()
                
//                Text("⏱: \(self.prefs.timer,  specifier: "%.f")s")
//                    .font(.largeTitle)
                Text("⏱: \(0)s")
                .font(.largeTitle)
                
                Spacer()

                Button(action: {
                    
                }) {
                    Text("PAUSE")
                        .padding(10)
                }.disabled(false)
                    .background(false ? Color.gray : Color.blue)
                    .cornerRadius(4.0)
            }.padding(20)
                .foregroundColor(.white)
                .background(Color(.clear))

            Spacer()
        }
    }
}

#if DEBUG

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
