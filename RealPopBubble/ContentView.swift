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
        ARView()
        .environmentObject(data)
        .edgesIgnoringSafeArea(.all)
        .overlay(ARKitBittomView())
    }
}

struct ARKitBittomView: View {
    @EnvironmentObject var data: DataModel
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Highest: \(self.data.highestScore)")
                    Text("Current: \(self.data.currentScore)")
                }

                Spacer()
                
                Text("⏱: \(self.data.timer,  specifier: "%.f")s")
                    .font(.largeTitle)
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
