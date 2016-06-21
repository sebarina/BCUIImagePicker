//
//  Utils.swift
//  BCUIImagePicker
//
//  Created by Sebarina Xu on 6/16/16.
//  Copyright © 2016 forzadata. All rights reserved.
//

import Foundation
import PhotosUI

class ImageUtil {
    static var sharedInstance = ImageUtil()
    private var operationQueue : [Int: PHImageRequestID] = [:]
    
    func loadImage(asset: PHAsset, imageView: UIImageView) {
        if operationQueue[imageView.hash] != nil {
            PHImageManager.defaultManager().cancelImageRequest(operationQueue[imageView.hash]!)
        }
        let scale = UIScreen.mainScreen().scale
        
        var mode : PHImageContentMode
        switch imageView.contentMode {
        case .ScaleAspectFit:
            mode = PHImageContentMode.AspectFit
        default:
            mode = PHImageContentMode.AspectFill
        }
        
        let loadSession = PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(imageView.frame.width*scale, imageView.frame.height*scale), contentMode: mode , options: nil) { ( data, info) in
            imageView.image = data
            
        }
        operationQueue[imageView.hash] = loadSession
        
    }
}
