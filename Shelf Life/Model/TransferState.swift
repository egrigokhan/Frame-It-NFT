//
//  TransferState.swift
//  Shelf Life
//
//  Created by Gokhan Egri on 26.06.2021.
//

import Foundation
import CoreGraphics
import SwiftUI

struct TransferState: Codable {
    var id: String
    
    var isThumbnail: Bool = false

    var isColor: Bool = false
    var colorRGB: [CGFloat] = []
    
    var offset: CGPoint
    var scale: CGFloat
    var imageData: Data
}
