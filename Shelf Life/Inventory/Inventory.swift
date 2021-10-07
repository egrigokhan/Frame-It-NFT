//
//  Inventory.swift
//  Shelf Life
//
//  Created by Gokhan Egri on 26.06.2021.
//

import Foundation
import UIKit

class Inventory: ObservableObject {
    
    @Published var defaultObjectPaths: [String] {
        didSet {
            generateImageViews()
        }
    }
    @Published var spectatorObjectPaths: [String] {
        didSet {
            generateImageViews()
        }
    }
    @Published var objectImageViews: [InventoryImageView]
    @Published var spectatorObjectImageViews: [InventoryImageView]
    
    init() {
        self.defaultObjectPaths = (UserDefaults(suiteName: "group.shelf-life")?.value(forKey: "shelf-life-default-inventory") ?? []) as! [String]

        // UserDefaults.standard.set([], forKey: "shelf-life-inventory")
        var paths_ = ["2", "3", "8", "9", "10"]
        paths_.append(contentsOf: ["vase-1", "vase-2"])
        paths_.append(contentsOf: ["basket-1"])
        paths_.append(contentsOf: ["book-1", "book-2"])
        paths_.append(contentsOf: ["plant-1", "plant-2", "plant-3", "plant-4", "plant-6", "plant-7"])
        paths_.append(contentsOf: ["trophy-1", "trophy-2"])
        paths_.append(contentsOf: ["statue-1", "statue-2", "statue-3", "statue-4"])
        paths_.append(contentsOf: ["prop-1", "prop-2"])
        paths_.append(contentsOf: ["frame-1"])
        
        paths_ = []

        for i in 1...16 {
            paths_.append("spec-" + String(i))
        }
        
        self.spectatorObjectPaths = paths_
        // self.defaultObjectPaths.append(contentsOf: paths_)
        
        // self.userAddedObjectPaths = (UserDefaults(suiteName: "group.shelf-life")?.value(forKey: "shelf-life-inventory") ?? []) as! [String]
        self.objectImageViews = []
        self.spectatorObjectImageViews = []
        self.generateImageViews()
    }
    
    private func generateImageViews() {
        self.objectImageViews = []

        for o in self.spectatorObjectPaths {
            do {
                var imageView = UIImage.init(named: o)
                self.spectatorObjectImageViews.append(InventoryImageView(imageView: imageView!))
            } catch {
                print("Error!")
            }
        }

        for o in self.defaultObjectPaths {
            if let image = UIImage.init(named: o) {
                self.objectImageViews.append(InventoryImageView(imageView: image))
            } else {
                do {
                    var data_ = UserDefaults(suiteName: "group.shelf-life")?.value(forKey: o) as! Data
                    var imageView = UIImage(data: data_)
                    self.objectImageViews.append(InventoryImageView(imageView: imageView!))
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
    
    func addImage(image: UIImage) {
        let imageData = image.pngData()
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
                                            let imageData = image!.pngData()
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
                                    let imageData = image!.pngData()
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
