//
//  Util.swift
//  Shelf Life
//
//  Created by Gokhan Egri on 20.06.2021.
//

import Foundation
import UIKit
import SwiftUI
import Photos

struct Util {
    
    static var BACKGROUND_COLORS = [
                                    Color.init(red: 94/255, green: 25/255, blue: 18/255),
                                    Color.init(red: 75/255, green: 74/255, blue: 49/255),
                                    Color.init(red: 103/255, green: 91/255, blue: 81/255),
                                    Color.init(red: 118/255, green: 138/255, blue: 147/255),
                                    Color.init(red: 207/255, green: 227/255, blue: 247/255),
                                    Color.init(red: 212/255, green: 244/255, blue: 245/255),
                                    Color.init(red: 241/255, green: 248/255, blue: 221/255),
                                    Color.init(red: 231/255, green: 225/255, blue: 213/255),
                                    Color.init(red: 244/255, green: 217/255, blue: 215/255),
                                    Color.init(red: 212/255, green: 206/255, blue: 232/255),
                                    Color.init(red: 237/255, green: 197/255, blue: 195/255),
                                    Color.init(red: 243/255, green: 228/255, blue: 190/255),
                                    Color.init(red: 245/255, green: 244/255, blue: 185/255),
                                    Color.init(red: 200/255, green: 243/255, blue: 199/255),
                                    Color.init(red: 196/255, green: 220/255, blue: 242/255)
                                    ]
    
    static func dummy() {}
    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
                
        var origin: CGPoint = CGPoint(x: (targetSize.width - image.size.width) / 2.0,
                                      y: (targetSize.height - image.size.height) / 2.0)
        
        let rect = CGRect(origin: origin, size: size)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    static func requestPixelatedImage(base64: String, success_callback: @escaping ([UIImage]) -> ()) -> [UIImage] {
        
        /*
        let urlString = "https://shelf-life-server.herokuapp.com/api/pixelate"
        
        AF.request(urlString, method: .post, parameters: ["original_base64": base64],encoding: JSONEncoding.default, headers: nil).responseJSON {
        response in
          switch response.result {
                        case .success:
                            print(response)

                            break
                        case .failure(let error):

                            print(error)
                        }
        }
        return []
        
        */
        // prepare json data
        let json: [String: Any] = ["original_base64": base64]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        let url = URL(string: "https://shelf-life-server.herokuapp.com/api/pixelate")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
         // Set HTTP Request Headers
         request.setValue("application/json", forHTTPHeaderField: "Accept")
         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
         
        // insert json data to the request
        request.httpBody = jsonData // Data.init(base64Encoded: base64) // base64.toByteArray() // jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                var pixel_images: [UIImage] = []
                
                for p in (responseJSON["pxl"] as! [[String:String]]) {
                    let imageData = Data(base64Encoded: p["py/b64"]!, options: .ignoreUnknownCharacters)

                    let image = UIImage(data: imageData!)
                    
                    pixel_images.append(image!)
                }
                
                success_callback(pixel_images)
            }
        }

        task.resume()
        
        return []
    }
    
    static func getWidgetSize(size: String) -> CGSize {
        if(size == "small") {
            switch UIScreen.main.bounds.size {
                case CGSize(width: 428, height: 926):   return CGSize(width: 170, height: 170)
                case CGSize(width: 414, height: 896):   return CGSize(width: 169, height: 169)
                case CGSize(width: 414, height: 736):   return CGSize(width: 159, height: 159)
                case CGSize(width: 390, height: 844):   return CGSize(width: 158, height: 158)
                case CGSize(width: 375, height: 812):   return CGSize(width: 155, height: 155)
                case CGSize(width: 375, height: 667):   return CGSize(width: 148, height: 148)
                case CGSize(width: 360, height: 780):   return CGSize(width: 155, height: 155)
                case CGSize(width: 320, height: 568):   return CGSize(width: 141, height: 141)
                default:                                return CGSize(width: 155, height: 155)
            }
        } else if(size == "medium") {
            switch UIScreen.main.bounds.size {
                case CGSize(width: 428, height: 926):   return CGSize(width: 364, height: 170)
                case CGSize(width: 414, height: 896):   return CGSize(width: 360, height: 169)
                case CGSize(width: 414, height: 736):   return CGSize(width: 348, height: 159)
                case CGSize(width: 390, height: 844):   return CGSize(width: 338, height: 158)
                case CGSize(width: 375, height: 812):   return CGSize(width: 329, height: 155)
                case CGSize(width: 375, height: 667):   return CGSize(width: 321, height: 148)
                case CGSize(width: 360, height: 780):   return CGSize(width: 329, height: 155)
                case CGSize(width: 320, height: 568):   return CGSize(width: 292, height: 141)
                default:                                return CGSize(width: 329, height: 155)
            }
        } else if(size == "large") {
            switch UIScreen.main.bounds.size {
                case CGSize(width: 428, height: 926):   return CGSize(width: 364, height: 382)
                case CGSize(width: 414, height: 896):   return CGSize(width: 360, height: 379)
                case CGSize(width: 414, height: 736):   return CGSize(width: 348, height: 357)
                case CGSize(width: 390, height: 844):   return CGSize(width: 338, height: 354)
                case CGSize(width: 375, height: 812):   return CGSize(width: 329, height: 345)
                case CGSize(width: 375, height: 667):   return CGSize(width: 321, height: 324)
                case CGSize(width: 360, height: 780):   return CGSize(width: 329, height: 345)
                case CGSize(width: 320, height: 568):   return CGSize(width: 292, height: 311)
                default:                                return CGSize(width: 329, height: 345)
            }
        }
        
        return CGSize.zero
    }
}

extension UIView {
    func asImage() -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        return UIGraphicsImageRenderer(size: self.layer.frame.size, format: format).image { context in
            self.drawHierarchy(in: self.layer.bounds, afterScreenUpdates: true)
        }
    }
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    
    func asImage(size: CGSize) -> UIImage {
        let controller = UIHostingController(rootView: self)
        controller.view.bounds = CGRect(origin: .init(x: 0, y: 0), size: size)
        let image = controller.view.asImage()
        return image
    }
}

/*
extension String {
    func toByteArray() -> [[Byte]] {
        var byteArray = [Byte]()
        for char in self.utf8{
            byteArray += [char]
        }
        return byteArray
    }
}

extension UIImage {
    func resizeWithTransparentPadding(size: CGSize = CGSize(width: 512, height: 512)) -> UIImage {
        var image = self.resized(to: CGSize(width: self.size.height * (512 / self.size.width), height: 512))
        if(self.size.width > self.size.height) {
            var image = self.resized(to: CGSize(width: 512, height: self.size.height * (512 / self.size.width)))
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        var context: CGContext = UIGraphicsGetCurrentContext()!
        UIGraphicsPushContext(context)

        var origin: CGPoint = CGPoint(x: (image.size.width - image.size.width) / 2.0,
                                      y: (image.size.height - image.size.height) / 2.0)
        image.draw(at: origin)

        UIGraphicsPopContext()
        var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
*/

class PhotosModel: ObservableObject {

    @Published var allPhotos = [UIImage]()
    @Published var allPhotosCount = 0
    @Published var errorString : String = ""

    init() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                self.errorString = ""
                self.getAllPhotos()
            case .denied, .restricted:
                self.errorString = "Photo access permission denied"
            case .notDetermined:
                self.errorString = "Photo access permission not determined"
            @unknown default:
                fatalError()
            }
        }
    }

    fileprivate func getAllPhotos() {

        let manager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let results: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if results.count > 0 {
            for i in 0..<results.count {
                let asset = results.object(at: i)
                let size = CGSize(width: 700, height: 700) //You can change size here
                manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { (image, _) in
                    if let image = image {
                        self.allPhotos.append(image)
                        self.allPhotosCount = self.allPhotos.count
                    } else {
                        print("error asset to image")
                    }
                }
            }
        } else {
            self.errorString = "No photos to display"
        }
    }
}
