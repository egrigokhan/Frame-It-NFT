//
//  InventoryImageView.swift
//  Shelf Life
//
//  Created by Gokhan Egri on 26.06.2021.
//

import Foundation
import UIKit
import CoreGraphics
import SwiftUI

struct InventoryImageView: View, Identifiable {
    
    let id = UUID()
    @State var imageView: UIImage
    @State var isNew: Bool = true
    
    var body: some View {
            ZStack {
                Color.init(UIColor.init(named: "light-background")!)
                Image(uiImage: self.imageView)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .padding()
            }.clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            .frame(minWidth: 80, maxWidth: 80, minHeight: 80, maxHeight: 80, alignment: Alignment.center)
    }
}
