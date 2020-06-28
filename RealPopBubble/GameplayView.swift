//
//  GameplayView.swift
//  RealPopBubble
//
//  Created by Nikita Sergeev on 9/6/20.
//  Copyright © 2020 Nikita Sergeev. All rights reserved.
//

import SwiftUI

struct GameplayView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var data: DataModel
    
    var body: some View {
        NavigationView {
            ARView()
            .environmentObject(data)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                VStack {
                    HStack {
                        VStack {
                            Text("Score: \(data.currentScore)")
                                .font(.title)
                        }

                        Spacer()
                        
                        Text("⏱: \(abs(data.timer),  specifier: "%.f")s")
                            .font(.largeTitle)
                        
                        Spacer()

                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("FINISH")
                                .padding(10)
                        }.disabled(false)
                            .background(Color.blue)
                            .cornerRadius(4.0)
                    }.padding(20)
                        .foregroundColor(.white)
                        .background(Color(.clear))

                    Spacer()
                }.hiddenNavigationBarStyle()
                    .zIndex(0)
            )
            .overlay(
                TapSurfaceMessage()
            )
            .overlay(
                VStack {
                    Spacer()
                    
                    if data.gameIsOver {
                        VStack {
                            VStack {
                                Text("Time is over ⏱")
                                Text("Score \(data.currentScore)!")
                            }.padding(.bottom, 50)
                            
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("MENU")
                                    .font(.title)
                                    .frame(width: 100, height: 40)
                                    .foregroundColor(.white)
                                    .padding(20)
                                    .background(Color.blue)
                                    .cornerRadius(4.0)
                            }
                        }.font(.title)
                            .padding(40)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(4.0)
                            .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                            .animation(.spring())
                            .zIndex(1)
                    }
                    
                    Spacer()
                }.hiddenNavigationBarStyle()
            )
        }.hiddenNavigationBarStyle()
    }
}

struct TapSurfaceMessage: View {
    @EnvironmentObject var data: DataModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                if self.data.surfaceIsScanned && !self.data.didSetOrigin {
                    Text("Tap on the green surface to set origin")
                    .font(.system(size: 20))
                    .padding(.top, 10)
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .transition(.move(edge: .bottom))
                    .animation(.spring())
                    .zIndex(1)
                }
            }.edgesIgnoringSafeArea(.bottom)
        }
    }
}
