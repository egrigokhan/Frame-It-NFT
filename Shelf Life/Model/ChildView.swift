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
    case FLOOR
}

struct AddShadows: ViewModifier {
    
    @State var scale: CGFloat
    
    init(scale: CGFloat) {
        self.scale = scale
    }
    
    func body(content: Content) -> some View {
        content.background(Color.white.shadow(color: Color.black.opacity(0.3), radius: 0.1, x: 12 / self.scale, y: 5 / self.scale))
        
            /*
            (color: Color.black.opacity(0.1), radius: 0.1, x: 5 +K 3.0 * 0.3, y: 5 + 4.0 * 0.7)
            
            */
            /*
            .shadow(color: Color.black.opacity(0.1), radius: 0.1, x: 0, y: 1 + 4 * sin(CGFloat(Double(Calendar.current.component(.hour, from: Date()))) / 24.0) * 3.14)
            .shadow(color: Color.black.opacity(0.1), radius: 0.1, x: 0.5 + 0.5 * cos(CGFloat((Double(Calendar.current.component(.hour, from: Date()))) / 24.0) * 3.14), y: 0)
            .shadow(color: Color.black.opacity(0.1), radius: 0.1, x: -0.5 + 0.5 * cos(CGFloat((Double(Calendar.current.component(.hour, from: Date()))) / 24.0) * 3.14), y: 0)
            */
    }
}

struct ChildView: Identifiable, View {
    
    var id = UUID()
        
    @ObservedObject var state: ChildViewState = ChildViewState.init(type: .COLOR, offset: .zero, scale: 1.0, imageView: UIImage(named: "2")!, imagePath: "2", colorComponents: [])

    init(type: ChildViewType, colorComponents: [CGFloat], offset: CGPoint, scale: CGFloat, imageView: UIImage, imagePath: String?) {
        self.state = ChildViewState.init(type: type, offset: offset, scale: scale, imageView: imageView, imagePath: imagePath, colorComponents: colorComponents)
        if(imagePath != nil && imagePath!.contains("spec_")) {
            self.state.type = .SPECTATOR
        }
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
            ZStack {
                VStack {
                    Image(uiImage: state.imageView)
                        // .interpolation(.medium)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80, alignment: .center)
                        .padding(16 / self.state.scale)
                        .border(Color.black, width: 6 / self.state.scale)
                        .modifier(AddShadows.init(scale: self.state.scale))
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
                                        self.state.scale = max(floor((value.magnitude * 80) / 5) * 5 / 80, 0.1)
                                    }
                                )
                }
            }.frame(height: 80, alignment: .center)
        case .SPECTATOR:
            VStack {
                Image(uiImage: state.imageView)
                    .interpolation(.medium)
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
        case .FLOOR:
            VStack {
                Image(uiImage: UIImage.init(named: "floor")!)
                    .interpolation(.medium)
                    .resizable()
                    .scaleEffect(x: 3, y: 1)
                    .frame(height: 32, alignment: .top)
                    // .scaleEffect(self.state.scale)
                    .clipped()
                    // .border(Color.red, width: 4)
            }
        default:
            VStack { }
        }
    }
}
