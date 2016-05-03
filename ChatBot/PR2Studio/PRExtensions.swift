//
//  PRExtensions.swift
//  FashionBrowserPablo
//
//  Created by Pablo Roca Rozas on 3/2/16.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import Foundation

import UIKit
import Alamofire
import AlamofireImage

extension String {
    func contains(find: String) -> Bool {
        return self.rangeOfString(find) != nil
    }
   
    func stringByAppendingPathComponent(path: String) -> String {
       let nsSt = self as NSString
       return nsSt.stringByAppendingPathComponent(path)
    }
}

extension Array {
    
    // Returns the index of first element satisfying the predicate, or 0
    // if there is no matching element.
    func PR2IndexforFirstMatching<L: BooleanType>(predicate: Element -> L) -> Int? {
        var index = 0
        for item in self {
            if predicate(item) {
                return index // found
            }
            index += 1
        }
        return nil // not found
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

// requires Alamofire / AlamofireImage / PR2Common
extension UIImageView {
    func PR2ImageFromNetwork(imageURL: String, indicatorStyle: UIActivityIndicatorViewStyle = UIActivityIndicatorViewStyle.White) {
        PR2Common().showNetworkActivityinStatusBar()
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: indicatorStyle)
        indicator.center = self.center;// it will display in center of image view
        self.addSubview(indicator)
        indicator.startAnimating()
        
        Alamofire.request(.GET, imageURL)
            .responseImage { response in
                PR2Common().hideNetworkActivityinStatusBar()
                indicator.stopAnimating()
                indicator.hidden = true
                indicator.removeFromSuperview()
                if let image = response.result.value {
                    //                    let image = UIImage(data: response.data!, scale: UIScreen.mainScreen().scale)!
                    self.image = image
                }
        }
    }
}

extension UIScrollView {
   
   func scrollToBottom(animated animated: Bool) {
      let rect = CGRect(x: 0, y: contentSize.height - bounds.size.height, width: bounds.size.width, height: bounds.size.height)
      scrollRectToVisible(rect, animated: animated)
   }
   
}
