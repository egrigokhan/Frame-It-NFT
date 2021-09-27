//
//  SocialShare.swift
//  Shelf Life
//
//  Created by Gokhan Egri on 10.07.2021.
//

import Social
import UIKit

public struct SocialMediaShareable {
    var image: UIImage?
    var url: URL?
    var text: String?
}

public class SocialMediaSharingManager {
    public static func shareOnFacebook(object: SocialMediaShareable) -> UIViewController? {
        return share(object: object, for: SLServiceTypeFacebook)
    }
    public static func shareOnTwitter(object: SocialMediaShareable) -> UIViewController? {
        return share(object: object, for: SLServiceTypeTwitter)
    }
    private static func share(object: SocialMediaShareable, for serviceType: String) -> UIViewController? {
        if let composeVC = SLComposeViewController(forServiceType:serviceType) {
            if let image = object.image {
                composeVC.add(image)
            }
            if let url = object.url {
                composeVC.add(url)
            }
            if let text = object.text {
                composeVC.setInitialText(text)

            }
            
            return composeVC
        }
        
        return nil
    }
}
