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
    var id: String {
        didSet {
            print("ts id : " + id)
        }
    }
    
    var isThumbnail: Bool = false

    var isColor: Bool = false
    var colorRGB: [CGFloat] = []
    
    var offset: CGPoint
    var scale: CGFloat
    var imageData: Data?
    var imagePath: String? {
        didSet {
            if(imagePath != nil) {
                if let image = UIImage.init(named: imagePath!) {
                    self.imageData = image.pngData()!
                } else {
                    do {
                        if let data_ = UserDefaults(suiteName: "group.shelf-life")?.value(forKey: imagePath!) as? Data {
                            var imageView = UIImage(data: data_)
                            self.imageData = imageView!.pngData()!
                        }
                    } catch {
                        print("Error!")
                    }
                }
            }
        }
    }
    
    mutating func setImageData() {
        if(imagePath != nil) {
            if let image = UIImage.init(named: imagePath!) {
                self.imageData = image.pngData()!
            } else {
                do {
                    if let data_ = UserDefaults(suiteName: "group.shelf-life")?.value(forKey: imagePath!) as? Data {
                        var imageView = UIImage(data: data_)
                        self.imageData = imageView!.pngData()!
                    }
                } catch {
                    print("Error!")
                }
            }
        } else {
            self.imageData = UIImage.init(named: "bob")?.pngData()
        }
    }
    
    mutating func clean() {
        self.imageData = nil
    }
}
