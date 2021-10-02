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
    @Published var thumbnailImage: UIImage
    
    init(widgetType: String, shelfVariant: String, shelfViews: [ChildView], thumbnailImage: UIImage) {
        self.widgetType = widgetType
        self.shelfVariant = shelfVariant
        self.thumbnailImage = thumbnailImage
        if(shelfViews.count >= 1) {
            self.shelfViews = Array(shelfViews[1..<(shelfViews.count)])
            self.backgroundColor = shelfViews[0]
        } else {
            self.shelfViews = []
            self.backgroundColor = ChildView.init(type: .COLOR, colorComponents: [1, 1, 0], offset: .zero, scale: 1.0, imageView: UIImage.init())
        }
        /*
        var temp_ = UserDefaultsFunctions.readObject(key: "widget_\(widgetType)\(shelfVariant)") as? Any
        print(temp_)
        if(temp_ != nil) {
            var temp = temp_ as! [String:[ChildView]]
            
            print("temp")
            print(temp)
            self.thumbnailImage = temp["thumbnail"]![0].state.imageView // temp[temp.count - 2].state.imageView
            /*
            if(temp.count >= 2) {
                print(temp[temp.count - 2].state.imageView)
                self.thumbnailImage = temp[temp.count - 2].state.imageView
            }
            */
            self.shelfViews = Array(temp["cv"]![1..<(temp["cv"]!.count)])
            self.backgroundColor = temp["cv"]![0]
        } else {
            self.thumbnailImage = UIImage.init(imageLiteralResourceName: "bob")
            self.shelfViews = []
            self.backgroundColor = ChildView.init(type: .COLOR, colorComponents: [255, 0, 255], offset: .zero, scale: 1, imageView: UIImage.init())
        }
        */
        
    }
}
