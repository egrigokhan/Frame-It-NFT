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

struct ChildColorView: Identifiable, View {
    
    var id = UUID()
        
    @ObservedObject var state: ChildColorViewState = ChildColorViewState.init(colorComponents: [])

    init(colorComponents: [CGFloat]) {
        print(colorComponents)
        self.state = ChildColorViewState.init(colorComponents: colorComponents)
    }
    
    var body: some View {
        if(state.colorComponents.count == 4) {
            Color.init(CGColor.init(red: state.colorComponents[0], green: state.colorComponents[1], blue: state.colorComponents[2], alpha: state.colorComponents[3]))
        } else {
            Color.init(UIColor.clear.cgColor)
        }
    }
}
