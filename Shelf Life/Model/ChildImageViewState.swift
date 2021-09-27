//
//  ChildImageViewState.swift
//  Shelf Life
//
//  Created by Gokhan Egri on 26.06.2021.
//

import Foundation
import UIKit
import CoreGraphics
import SwiftUI

class ChildImageViewState: ObservableObject {
    @Published var offset: CGPoint = .zero
    @Published var scale: CGFloat = 1.0
    @Published var imageView: UIImage
    
    init(offset: CGPoint, scale: CGFloat, imageView: UIImage) {
        self.imageView = imageView
        self.offset = offset
        self.scale = scale
    }
}
