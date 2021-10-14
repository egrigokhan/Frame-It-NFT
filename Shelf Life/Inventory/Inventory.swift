//
//  Inventory.swift
//  Shelf Life
//
//  Created by Gokhan Egri on 26.06.2021.
//

import Foundation
import UIKit

struct CollectionRowView: Identifiable {
    
    let id = UUID()
    var collectionId: String
    var collectionTitle: String
    var collectionPaths: [String]
    var collectionImageViews: [InventoryImageView]
}


class Inventory: ObservableObject {
    
    @Published var defaultObjectPaths: [String] {
        didSet {
            generateImageViews()
        }
    }
    @Published var collections: [[String:Any]] {
        didSet {
            generateCollectionImageViews()
        }
    }
    @Published var spectatorObjectPaths: [String] {
        didSet {
            generateImageViews()
        }
    }
    @Published var objectImageViews: [InventoryImageView]
    @Published var collectionImageViews: [CollectionRowView]
    @Published var spectatorObjectImageViews: [InventoryImageView]
    
    init() {
        self.collections = (UserDefaults(suiteName: "group.shelf-life")?.value(forKey: "shelf-life-collections") ?? []) as! [[String:Any]] // [["id": "before_sunrise", "title": "Before Sunrise", "paths": ["placeholder"]], ["id": "bob_dylan", "title": "Bob Dylan", "paths": ["placeholder", "bob_2"]]]//
        self.defaultObjectPaths = (UserDefaults(suiteName: "group.shelf-life")?.value(forKey: "shelf-life-default-inventory") ?? []) as! [String]

        // UserDefaults.standard.set([], forKey: "shelf-life-inventory")
        var paths_: [String] = []

        for i in 1...16 {
            paths_.append("spec-" + String(i))
        }
        
        self.spectatorObjectPaths = paths_
        // self.defaultObjectPaths.append(contentsOf: paths_)
        
        self.defaultObjectPaths = (UserDefaults(suiteName: "group.shelf-life")?.value(forKey: "shelf-life-inventory") ?? []) as! [String]
        self.objectImageViews = []
        self.collectionImageViews = []
        self.spectatorObjectImageViews = []
        self.generateImageViews()
        self.generateCollectionImageViews()
    }
    
    private func generateCollectionImageViews() {
        self.collectionImageViews = []
        
        for (i, c) in (self.collections).enumerated() {
            var imageViews: [InventoryImageView] = []
            for o in (c["paths"] as! [String]) {
                if let image = UIImage.init(named: o) {
                    // imageViews.append(InventoryImageView(imageView: image))
                    imageViews.append(InventoryImageView(imagePath: o, imageView: image))
                } else {
                    do {
                        if let data_ = UserDefaults(suiteName: "group.shelf-life")?.value(forKey: o) as? Data {
                            var imageView = UIImage(data: data_)
                            imageViews.append(InventoryImageView(imagePath: o, imageView: imageView!))
                        }
                    } catch {
                        print("Error!")
                    }
                }
            }
            
            
            self.collectionImageViews.append(CollectionRowView.init(collectionId: c["id"] as! String, collectionTitle: c["title"] as! String, collectionPaths: c["paths"] as! [String], collectionImageViews: imageViews))
        }
    }
    
    private func generateImageViews() {
        self.objectImageViews = []

        for o in self.spectatorObjectPaths {
            do {
                var imageView = UIImage.init(named: o)
                self.spectatorObjectImageViews.append(InventoryImageView(imagePath: o, imageView: imageView!))
            } catch {
                print("Error!")
            }
        }

        for o in self.defaultObjectPaths {
            if let image = UIImage.init(named: o) {
                self.objectImageViews.append(InventoryImageView(imagePath: o, imageView: image))
            } else {
                do {
                    var data_ = UserDefaults(suiteName: "group.shelf-life")?.value(forKey: o) as! Data
                    var imageView = UIImage(data: data_)
                    self.objectImageViews.append(InventoryImageView(imagePath: o, imageView: imageView!))
                } catch {
                    print("Error!")
                }
            }
        }
    }
    
    func documentsPathForFileName(name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true);
        let path = paths[0] as String;
        print(path)
        print(name)

        return path + "/" + name
    }
    
    static func documentsPathForFileName(name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true);
        let path = paths[0] as String;
        print(path)
        print(name)

        return path + "/" + name
    }
    
    func addImage(image: UIImage) -> String {
        let imageData = image.jpegData(compressionQuality: 0.3)
        let relativePath = "shelf_life_user_added_\(NSDate.timeIntervalSinceReferenceDate)"
        let path = self.documentsPathForFileName(name: relativePath)
        do {
            UserDefaults(suiteName: "group.shelf-life")!.set(imageData, forKey: relativePath)
            var currentInventory = (UserDefaults(suiteName: "group.shelf-life")?.value(forKey: "shelf-life-inventory") ?? []) as! [String]
            currentInventory.append(relativePath)
            UserDefaults(suiteName: "group.shelf-life")!.set(currentInventory, forKey: "shelf-life-inventory")
            // UserDefaults.standard.set(relativePath, forKey: "shelf-life-inventory")
            UserDefaults(suiteName: "group.shelf-life")!.synchronize()
        } catch {
            print("Error!")
        }
        return relativePath
    }
    
    static func addImageToCollection(image: UIImage, collectionId: String) -> String {
        let imageData = image.jpegData(compressionQuality: 0.3)
        let relativePath = "shelf_life_user_added_\(NSDate.timeIntervalSinceReferenceDate)"
        let path = self.documentsPathForFileName(name: relativePath)
        do {
            UserDefaults(suiteName: "group.shelf-life")!.set(imageData, forKey: relativePath)
            var currentInventory = (UserDefaults(suiteName: "group.shelf-life")?.value(forKey: "shelf-life-inventory") ?? []) as! [String]
            currentInventory.append(relativePath)
            UserDefaults(suiteName: "group.shelf-life")!.set(currentInventory, forKey: "shelf-life-inventory")
            // UserDefaults.standard.set(relativePath, forKey: "shelf-life-inventory")
            
            var collections_  = (UserDefaults(suiteName: "group.shelf-life")?.value(forKey: "shelf-life-collections") ?? []) as! [[String:Any]]
            var collectionExists = false
            for (i, c) in collections_.enumerated() {
                if c["id"] as! String == collectionId {
                    var paths_copy = (c["paths"] as! [String])
                    paths_copy.insert(relativePath, at: 0)
                    collections_[i]["paths"] = paths_copy
                    collectionExists = true
                }
            }
            UserDefaults(suiteName: "group.shelf-life")!.set(collections_, forKey: "shelf-life-collections")
            
            UserDefaults(suiteName: "group.shelf-life")!.synchronize()
        } catch {
            print("Error!")
        }
        return relativePath
    }
    
    func addCollection(collection: CollectionRowView, image: UIImage) {
        let relativePath = addImage(image: image)
        var collections_  = (UserDefaults(suiteName: "group.shelf-life")?.value(forKey: "shelf-life-collections") ?? []) as! [[String:Any]]
        var collectionExists = false
        for (i, c) in collections_.enumerated() {
            if c["id"] as! String == collection.collectionId {
                var paths_copy = (c["paths"] as! [String])
                paths_copy.insert(relativePath, at: 0)
                collections_[i]["paths"] = paths_copy
                collectionExists = true
            }
        }
        if(!collectionExists) {
            collections_.insert(["id": collection.collectionId, "title": collection.collectionTitle, "paths": [relativePath], "imageViews": []], at: 0)
        }
        UserDefaults(suiteName: "group.shelf-life")!.set(collections_, forKey: "shelf-life-collections")
        UserDefaults(suiteName: "group.shelf-life")!.synchronize()
    }
    
    func updateInventoryFromOpenSea(accountAddress: String = "0x198c46f639357ac2b288dafb81ed46f3d745bb31") {
        var currentDefaultInventory = (UserDefaults(suiteName: "group.shelf-life")?.value(forKey: "shelf-life-default-inventory") ?? []) as! [String]
        
        let url = URL(string: "https://api.opensea.io/api/v1/assets?owner=" + accountAddress + "&order_direction=desc&offset=0&limit=50")
        URLSession.shared.dataTask(with: url!, completionHandler: { [self]
                (data, response, error) in
                if(error != nil){
                    print("error")
                }else{
                    do{
                        var data_ = try (JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String:Any])
                        var data = data_["assets"] as! [[String:Any]]

                        for item in data {
                            do {
                                if(!currentDefaultInventory.contains(String(item["id"] as! Int))) {
                                    downloadImage(from: URL.init(string: item["image_preview_url"] as! String)!) { image in
                                        if(image != nil) {
                                            let imageData = image!.jpegData(compressionQuality: 0.3)
                                            let relativePath = String(item["id"] as! Int) as! String
                                            let path = self.documentsPathForFileName(name: relativePath)
                                            do {
                                                UserDefaults(suiteName: "group.shelf-life")!.set(imageData, forKey: relativePath)
                                                currentDefaultInventory.append(relativePath)
                                                UserDefaults(suiteName: "group.shelf-life")!.set(currentDefaultInventory, forKey: "shelf-life-default-inventory")
                                                // UserDefaults.standard.set(relativePath, forKey: "shelf-life-inventory")
                                                UserDefaults(suiteName: "group.shelf-life")!.synchronize()
                                            } catch {
                                                print("Error!")
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }

                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        
        (UserDefaults(suiteName: "group.shelf-life")?.value(forKey: "shelf-life-inventory") ?? []) as! [String]
    }
    
    func updateInventory() {
        var currentDefaultInventory = (UserDefaults(suiteName: "group.shelf-life")?.value(forKey: "shelf-life-default-inventory") ?? []) as! [String]
        
        let url = URL(string: "https://raw.githubusercontent.com/egrigokhan/shelf-life-inventory/main/inventory.html")
        URLSession.shared.dataTask(with: url!, completionHandler: { [self]
                (data, response, error) in
                if(error != nil){
                    print("error")
                }else{
                    do{
                        let data = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [[String:String]]

                        for item in data {
                            if(!currentDefaultInventory.contains(item["title"]!)) {
                                downloadImage(from: URL.init(string: item["url"]!)!) { image in
                                    let imageData = image!.jpegData(compressionQuality: 0.3)
                                    let relativePath = item["title"]!
                                    let path = self.documentsPathForFileName(name: relativePath)
                                    do {
                                        UserDefaults(suiteName: "group.shelf-life")!.set(imageData, forKey: relativePath)
                                        currentDefaultInventory.append(relativePath)
                                        UserDefaults(suiteName: "group.shelf-life")!.set(currentDefaultInventory, forKey: "shelf-life-default-inventory")
                                        // UserDefaults.standard.set(relativePath, forKey: "shelf-life-inventory")
                                        UserDefaults(suiteName: "group.shelf-life")!.synchronize()
                                    } catch {
                                        print("Error!")
                                    }
                                }
                            }
                        }

                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
        
        (UserDefaults(suiteName: "group.shelf-life")?.value(forKey: "shelf-life-inventory") ?? []) as! [String]
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> ()) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            completion(UIImage.init(data: data))
        }
    }
}
