//
//  ChildColorViewState.swift
//  Shelf Life
//
//  Created by Gokhan Egri on 1.08.2021.
//

import Foundation
import UIKit
import CoreGraphics
import SwiftUI

class ChildColorViewState: ObservableObject {
    @Published var colorComponents: [CGFloat]
    
    init(colorComponents: [CGFloat]) {
        self.colorComponents = colorComponents
    }
}

