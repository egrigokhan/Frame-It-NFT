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
    @State var imagePath: String {
        didSet {
            if let image = UIImage.init(named: imagePath) {
                self.imageView = image
            } else {
                do {
                    if let data_ = UserDefaults(suiteName: "group.shelf-life")?.value(forKey: imagePath) as? Data {
                        var imageView = UIImage(data: data_)
                        self.imageView = imageView!
                    }
                } catch {
                    print("Error!")
                }
            }
        }
    }
    @State var imageView: UIImage = UIImage.init(named: "bob")!
    @State var isNew: Bool = true
    
    var body: some View {
            ZStack {
                Color.init(UIColor.init(named: "light-background")!)
                if(self.imageView != nil) {
                    Image(uiImage: self.imageView)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .padding()
                }
            }.clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            .frame(minWidth: 80, maxWidth: 80, minHeight: 80, maxHeight: 80, alignment: Alignment.center)
    }
    
    mutating func setImageView() {
        if(imagePath != nil) {
            if let image = UIImage.init(named: imagePath) {
                self.imageView = image
            } else {
                do {
                    if let data_ = UserDefaults(suiteName: "group.shelf-life")?.value(forKey: imagePath) as? Data {
                        var imageView = UIImage(data: data_)
                        self.imageView = imageView!
                    }
                } catch {
                    print("Error!")
                }
            }
        } else {
            self.imageView = UIImage.init(named: "bob")!
        }
    }
}
