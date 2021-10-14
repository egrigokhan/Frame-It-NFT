//
//  ChildViewState.swift
//  Shelf Life
//
//  Created by Gokhan Egri on 1.08.2021.
//

import Foundation
import UIKit
import CoreGraphics
import SwiftUI

class ChildViewState: ObservableObject {
    @Published var type: ChildViewType = .COLOR
    
    @Published var offset: CGPoint = .zero
    @Published var scale: CGFloat = 1.0
    @Published var imageView: UIImage
    @Published var imagePath: String?
    
    @Published var colorComponents: [CGFloat]

    init(type: ChildViewType, offset: CGPoint, scale: CGFloat, imageView: UIImage, imagePath: String?, colorComponents: [CGFloat]) {
        self.type = type
        self.imageView = imageView
        self.imagePath = imagePath
        self.offset = offset
        self.scale = scale
        self.colorComponents = colorComponents
    }
}
