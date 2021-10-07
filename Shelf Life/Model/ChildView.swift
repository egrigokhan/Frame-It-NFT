//
//  ChildView.swift
//  Shelf Life
//
//  Created by Gokhan Egri on 1.08.2021.
//

import Foundation
import UIKit
import CoreGraphics
import SwiftUI

enum ChildViewType {
    case COLOR
    case IMAGE
    case SPECTATOR
}

struct ChildView: Identifiable, View {
    
    var id = UUID()
        
    @ObservedObject var state: ChildViewState = ChildViewState.init(type: .COLOR, offset: .zero, scale: 1.0, imageView: UIImage(named: "2")!, colorComponents: [])

    init(type: ChildViewType, colorComponents: [CGFloat], offset: CGPoint, scale: CGFloat, imageView: UIImage) {
        self.state = ChildViewState.init(type: type, offset: offset, scale: scale, imageView: imageView, colorComponents: colorComponents)
    }
    
    var body: some View {
        switch self.state.type {
        case .COLOR:
            if(state.colorComponents.count == 4) {
                Color.init(CGColor.init(red: state.colorComponents[0], green: state.colorComponents[1], blue: state.colorComponents[2], alpha: state.colorComponents[3]))
            } else {
                Color.init(UIColor.clear.cgColor)
            }
        case .IMAGE:
            VStack {
                Image(uiImage: state.imageView)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80, alignment: .center)
                    .padding(16 / self.state.scale)
                    .border(Color.black, width: 6 / self.state.scale)
                    .background(Color.white)
                    .scaleEffect(self.state.scale)
                    .offset(x: self.state.offset.x, y: self.state.offset.y)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                self.state.offset = gesture.location
                                self.state.offset = CGPoint.init(x: floor(gesture.location.x / 5) * 5 - 6 / self.state.scale, y: floor(gesture.location.y / 5) * 5 - 6 / self.state.scale)
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                                .onChanged { value in
                                    self.state.scale = floor((value.magnitude * 80) / 5) * 5 / 80
                                }
                            )
            }
        case .SPECTATOR:
            VStack {
                Image(uiImage: state.imageView)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80, alignment: .center)
                    .padding(16 / self.state.scale)
                    .scaleEffect(self.state.scale)
                    .offset(x: self.state.offset.x, y: self.state.offset.y)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                self.state.offset = gesture.location
                                self.state.offset = CGPoint.init(x: floor(gesture.location.x / 5) * 5 - 6 / self.state.scale, y: floor(gesture.location.y / 5) * 5 - 6 / self.state.scale)
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                                .onChanged { value in
                                    self.state.scale = floor((value.magnitude * 80) / 5) * 5 / 80
                                }
                            )
            }
        default:
            VStack { }
        }
    }
}
