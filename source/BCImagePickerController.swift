//
//  UTImagePickerController.swift
//  UTeacher
//
//  Created by Sebarina Xu on 1/18/16.
//  Copyright © 2016 liufan. All rights reserved.
//

import UIKit
import Photos

@objc public protocol BCImagePickerControllerDelegate: UINavigationControllerDelegate {
    func didFinishedPickImages(picker: BCImagePickerController, selectedAssets: [PHAsset])
    optional func didCancelPickImages()
}

public class BCImagePickerController: UINavigationController, UIAlertViewDelegate {
    
    public var appearance : BCImagePickerAppearance = BCImagePickerAppearance() {
        didSet {
            navigationBar.barTintColor = appearance.navBarColor
            navigationBar.backgroundColor = appearance.navBarColor
            navigationBar.tintColor = appearance.titleColor
            if navigationBar.titleTextAttributes == nil {
                navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: appearance.titleColor]
            } else {
                navigationBar.titleTextAttributes![NSForegroundColorAttributeName] = appearance.titleColor
            }
            
        }
    }
    public weak var imagePickerDelegate: BCImagePickerControllerDelegate?
    
    public init() {
        let albumPicker = BCAlbumPickerController()
        super.init(rootViewController: albumPicker)
        checkPhotoAuth()
        
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    public func selectedAssets(assets: [PHAsset]) {
        if assets.count > 0 {
            imagePickerDelegate?.didFinishedPickImages(self, selectedAssets: assets)
        } else {
            imagePickerDelegate?.didCancelPickImages?()
        }
        
    }
    
    public func checkPhotoAuth() {
        PHPhotoLibrary.requestAuthorization { (status) -> Void in
            switch status {
            case .Restricted:
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let photoAuthAlert = UIAlertView(
                        title: NSLocalizedString("访问受限", comment: "to the photo library"),
                        message: NSLocalizedString("你好像没有授权访问你的照片库，请去设置中心开通权限", comment: ""),
                        delegate: self,
                        cancelButtonTitle: NSLocalizedString("OK", comment: "")
                    )
                    photoAuthAlert.show()
                })
            case .Denied:
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let photoAuthAlert = UIAlertView(
                        title: NSLocalizedString("请开通权限", comment: "to the photo library"),
                        message: NSLocalizedString("App需要访问你的图片库. 请前往 设置 > 隐私 > 照片，然后为这个App开启权限", comment: ""),
                        delegate: self,
                        cancelButtonTitle: NSLocalizedString("OK", comment: ""),
                        otherButtonTitles: NSLocalizedString("Settings", comment: "")
                    )
                    photoAuthAlert.show()
                })
    
            default:
                
                break
            }
        }
    }
    
    public func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }
        imagePickerDelegate?.didCancelPickImages?()
        dismissViewControllerAnimated(true, completion: nil)
    }

}
