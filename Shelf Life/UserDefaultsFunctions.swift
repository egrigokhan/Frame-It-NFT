//
//  UserDefaultsFunctions.swift
//  Shelf Life
//
//  Created by Gokhan Egri on 20.06.2021.
//

import Foundation
import UIKit
import SwiftUI
import WidgetKit

struct UserDefaultsFunctions {
    
    static func dummy() {}
    
    static func saveVariant(key: String, value: [String:String]) {
        let userDefaults = UserDefaults(suiteName: "group.shelf-life")
        
        userDefaults!.set(value, forKey: key)
    }
    
    static func readVariant(key: String) -> [String:String] {
        let userDefaults = UserDefaults(suiteName: "group.shelf-life")
        
        if let value = userDefaults!.value(forKey: key) {
            return value as! [String:String]
        } else {
            return ["VARIANT_LARGE": "",
                    "VARIANT_MEDIUM": "",
                    "VARIANT_SMALL": ""]
        }
        
    }
    
    static func saveTimelineObject(key: String, value: [[String:[TransferState]]]) {
        let userDefaults = UserDefaults(suiteName: "group.shelf-life")
        
        let encoder = JSONEncoder()

        if let data = try? encoder.encode(value) {
            userDefaults!.set(data, forKey: key)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    static func addTimelineObject(key: String, value: [String:[TransferState]], index: Int) {
        let userDefaults = UserDefaults(suiteName: "group.shelf-life")
        
        let decoder = JSONDecoder()
        
        if let v = userDefaults!.value(forKey: key) {
            if var d = try? decoder.decode([[String:[TransferState]]].self, from: (v as! Data)) {
                
                if(index == -1) {
                    d.append(value)
                } else {
                    d[index] = value
                }
                
                let encoder = JSONEncoder()

                if let data = try? encoder.encode(d) {
                    userDefaults!.set(data, forKey: key)
                    WidgetCenter.shared.reloadAllTimelines()
                }
            } else {
                let encoder = JSONEncoder()

                if let data = try? encoder.encode([value]) {
                    userDefaults!.set(data, forKey: key)
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
        } else {
            let encoder = JSONEncoder()

            if let data = try? encoder.encode([value]) {
                userDefaults!.set(data, forKey: key)
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
    
    static func readTimelineObject(key: String) -> [[String:[ChildView]]] {
        let userDefaults = UserDefaults(suiteName: "group.shelf-life")
        
        let decoder = JSONDecoder()
        
        if let value = userDefaults!.value(forKey: key) {
            if let d = try? decoder.decode([[String:[TransferState]]].self, from: (value as! Data)) {
                var returnObjects: [[String:[ChildView]]] = []
                
                d.forEach { data_ in
                    let data = data_["ts"]
                    var civ: [ChildView] = []
                    var backgroundColor: ChildView = ChildView.init(type: .COLOR, colorComponents: UIColor.clear.cgColor.components!, offset: .zero, scale: 1.0, imageView: UIImage.init())
                    var thumbnailImage: ChildView = ChildView.init(type: .COLOR, colorComponents: UIColor.clear.cgColor.components!, offset: .zero, scale: 1.0, imageView: UIImage.init())

                    for ts in data! {
                        if(ts.isColor) {
                            backgroundColor = ChildView.init(type: .COLOR, colorComponents: ts.colorRGB, offset: .zero, scale: 1.0, imageView: UIImage.init())
                        } else {
                            var view: ChildView
                                // var data_ = UserDefaults(suiteName: "group.shelf-life")?.value(forKey: ts.imageId) as! Data
                                var imageView = UIImage(data: ts.imageData)
                            view = ChildView.init(type: .IMAGE, colorComponents: [], offset: ts.offset, scale: ts.scale, imageView: imageView!)
                            
                            
                            view.state.offset = ts.offset
                            view.state.scale = ts.scale

                            civ.append(view)
                        }
                    }
                    civ.insert(backgroundColor, at: 0)

                    if(data_["thumbnail"]![0] != nil) {
                        returnObjects.append(["thumbnail": [ChildView.init(type: .IMAGE, colorComponents: [], offset: .zero, scale: 1.0, imageView:  UIImage(data: data_["thumbnail"]![0].imageData)!)], "cv": civ])
                    } else {
                        returnObjects.append(["thumbnail": [ChildView.init(type: .IMAGE, colorComponents: [], offset: .zero, scale: 1.0, imageView:  UIImage(data: data_["thumbnail"]![0].imageData)!)], "cv": civ])
                    }
                }
                return returnObjects
            }
            return []
        } else {
            return []
        }
    }
    
    static func saveObject(key: String, value: [String:[TransferState]]) {
        let userDefaults = UserDefaults(suiteName: "group.shelf-life")
        
        let encoder = JSONEncoder()

        if let data = try? encoder.encode(value) {
            userDefaults!.set(data, forKey: key)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    static func readObject(key: String) -> [String:[ChildView]] {
        let userDefaults = UserDefaults(suiteName: "group.shelf-life")
        
        let decoder = JSONDecoder()
        
        if let value = userDefaults!.value(forKey: key) {
            if let data_ = try? decoder.decode([String:[TransferState]].self, from: (value as! Data)) {
                let data = data_["ts"]
                var civ: [ChildView] = []
                var backgroundColor: ChildView = ChildView.init(type: .COLOR, colorComponents: UIColor.clear.cgColor.components!, offset: .zero, scale: 1.0, imageView: UIImage.init())
                var thumbnailImage: ChildView = ChildView.init(type: .COLOR, colorComponents: UIColor.clear.cgColor.components!, offset: .zero, scale: 1.0, imageView: UIImage.init())

                for ts in data! {
                    if(ts.isColor) {
                        backgroundColor = ChildView.init(type: .COLOR, colorComponents: ts.colorRGB, offset: .zero, scale: 1.0, imageView: UIImage.init())
                    } else {
                        var view: ChildView
                            // var data_ = UserDefaults(suiteName: "group.shelf-life")?.value(forKey: ts.imageId) as! Data
                            var imageView = UIImage(data: ts.imageData)
                        view = ChildView.init(type: .IMAGE, colorComponents: [], offset: ts.offset, scale: ts.scale, imageView: imageView!)
                        
                        
                        view.state.offset = ts.offset
                        view.state.scale = ts.scale

                        civ.append(view)
                    }
                }
                civ.insert(backgroundColor, at: 0)

                if(data_["thumbnail"]![0] as? Data != nil) {
                    return ["thumbnail": [ChildView.init(type: .IMAGE, colorComponents: [], offset: .zero, scale: 1.0, imageView:  UIImage(data: data_["thumbnail"]![0].imageData)!)], "cv": civ]
                } else {
                    return ["thumbnail": [ChildView.init(type: .IMAGE, colorComponents: [], offset: .zero, scale: 1.0, imageView:  UIImage(data: data_["thumbnail"]![0].imageData)!)], "cv": civ]
                }
            }
            return ["thumbnail": [ChildView.init(type: .IMAGE, colorComponents: [], offset: .zero, scale: 1.0, imageView:  UIImage(imageLiteralResourceName: "bob"))], "cv": [ChildView.init(type: .COLOR, colorComponents: UIColor.clear.cgColor.components!, offset: .zero, scale: 1.0, imageView: UIImage.init())]]
        } else {
            return ["thumbnail": [ChildView.init(type: .IMAGE, colorComponents: [], offset: .zero, scale: 1.0, imageView:  UIImage(imageLiteralResourceName: "bob"))], "cv": [ChildView.init(type: .COLOR, colorComponents: UIColor.clear.cgColor.components!, offset: .zero, scale: 1.0, imageView: UIImage.init())]]
        }
    }
}
