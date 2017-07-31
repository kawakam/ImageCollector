//
//  Image.swift
//  ImageGetter
//
//  Created by 川上智樹 on 2015/11/01.
//  Copyright © 2015年 yatuhasiumai. All rights reserved.
//

import UIKit
import Alamofire

class Image: NSObject {
    
    var url: String!
    var img: UIImage!
    var selected: Bool = false

    init(url: String, callback: @escaping () -> Void) {
        super.init()
        self.url = url
        let req = Alamofire.request(url)
        req.response() { response in
            if response.error == nil {
                DispatchQueue.main.async { () in
                    let resizedImg = self.resizeImage(UIImage(data: response.data! as Data)!)
                    self.img = resizedImg
                    callback()
                }
            }
        }
    }
    
    func resizeImage(_ image :UIImage) ->UIImage {
        
        let origRef    = image.cgImage;
        let origWidth  = Int((origRef?.width)!)
        let origHeight = Int((origRef?.height)!)
        var resizeWidth:Int = 0
        var resizeHeight:Int = 0
        
        if image.size.width > 700 || image.size.height > 700 {
            
            resizeWidth = origWidth / 9
            resizeHeight = origHeight / 9
            let resizeSize = CGSize(width: CGFloat(resizeWidth), height: CGFloat(resizeHeight))
            UIGraphicsBeginImageContext(resizeSize)
            image.draw(in: CGRect(x: 0, y: 0, width: CGFloat(resizeWidth), height: CGFloat(resizeHeight)))
            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return resizeImage!
        

        } else if image.size.width > 600 || image.size.height > 600 {
            
            resizeWidth = origWidth / 7
            resizeHeight = origHeight / 7
            let resizeSize = CGSize(width: CGFloat(resizeWidth), height: CGFloat(resizeHeight))
            UIGraphicsBeginImageContext(resizeSize)
            image.draw(in: CGRect(x: 0, y: 0, width: CGFloat(resizeWidth), height: CGFloat(resizeHeight)))
            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return resizeImage!
            
        } else if image.size.width > 500 || image.size.height > 500 {
            
            resizeWidth = origWidth / 6
            resizeHeight = origHeight / 6
            let resizeSize = CGSize(width: CGFloat(resizeWidth), height: CGFloat(resizeHeight))
            UIGraphicsBeginImageContext(resizeSize)
            image.draw(in: CGRect(x: 0, y: 0, width: CGFloat(resizeWidth), height: CGFloat(resizeHeight)))
            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return resizeImage!
            
        } else if image.size.width > 400 || image.size.height > 400 {
            
            resizeWidth = origWidth / 5
            resizeHeight = origHeight / 5
            let resizeSize = CGSize(width: CGFloat(resizeWidth), height: CGFloat(resizeHeight))
            UIGraphicsBeginImageContext(resizeSize)
            image.draw(in: CGRect(x: 0, y: 0, width: CGFloat(resizeWidth), height: CGFloat(resizeHeight)))
            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return resizeImage!

        } else {
            return image
        }
    }
}

