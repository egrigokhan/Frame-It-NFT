//
//  ShelfBuildViewState.swift
//  Shelf Life
//
//  Created by Gokhan Egri on 1.08.2021.
//

import Foundation
import UIKit
import CoreGraphics
import SwiftUI

class ShelfBuildViewState: ObservableObject {
    @Published var widgetType: String
    @Published var shelfVariant: String
    @Published var shelfViews: [ChildView]
    @Published var backgroundColor: ChildView
    
    init(widgetType: String, shelfVariant: String) {
        self.widgetType = widgetType
        self.shelfVariant = shelfVariant
        let temp = UserDefaultsFunctions.readObject(key: "widget_\(widgetType)\(shelfVariant)")
        self.shelfViews = Array(temp[1...])
        self.backgroundColor = temp[0]
    }
}
