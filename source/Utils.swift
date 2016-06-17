//
//  Utils.swift
//  BCUIImagePicker
//
//  Created by Sebarina Xu on 6/16/16.
//  Copyright © 2016 forzadata. All rights reserved.
//

import Foundation
import PhotosUI

let _mutableRequestIDKey = malloc(4)

extension UIImageView {
    private var loadSession: PHImageRequestID? {
        get {
            return objc_getAssociatedObject(self, _mutableRequestIDKey) as? PHImageRequestID
        }
        set {
            objc_setAssociatedObject(self, _mutableRequestIDKey, newValue as? AnyObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func loadImageFromAsset(asset: PHAsset) {
        if loadSession != nil {
            PHImageManager.defaultManager().cancelImageRequest(loadSession!)
        }
        let scale = UIScreen.mainScreen().scale
        
        var mode : PHImageContentMode
        switch contentMode {
        case .ScaleAspectFit:
            mode = PHImageContentMode.AspectFit
        default:
            mode = PHImageContentMode.AspectFill
        }
        
        loadSession = PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(frame.width*scale, frame.height*scale), contentMode: mode , options: nil) { [weak self]( data, info) in
            self?.image = data
            self?.loadSession = nil
        }
    }
}
