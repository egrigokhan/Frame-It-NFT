//
//  ChildImageView.swift
//  Shelf Life
//
//  Created by Gokhan Egri on 26.06.2021.
//

import Foundation
import UIKit
import CoreGraphics
import SwiftUI

struct ChildImageView: Identifiable, View {
    
    var id = UUID()
    
    @ObservedObject var state: ChildImageViewState = ChildImageViewState.init(offset: .zero, scale: 1.0, imageView: UIImage(named: "bob")!)
    
    init(offset_: CGPoint? = .zero,
         scale_: CGFloat? = 1.0,
         imageView: UIImage) {
            self.state = ChildImageViewState.init(offset: offset_!, scale: scale_!, imageView: imageView)
        }
    
    var body: some View {
        VStack {
            Image(uiImage: state.imageView)
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(height: 80, alignment: .center)
                .padding(16 / self.state.scale)
                // .background(Color.white)
                // .border(Color.black, width: 6 / self.state.scale)
                .scaleEffect(self.state.scale)
                .offset(x: self.state.offset.x, y: self.state.offset.y)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                        self.state.offset = gesture.location
                        }
                )
                .gesture(
                    MagnificationGesture()
                            .onChanged { value in
                    self.state.scale = value.magnitude
                            }
                        )
        }
    }
}
