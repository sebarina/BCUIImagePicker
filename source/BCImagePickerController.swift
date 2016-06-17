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
    weak var imagePickerDelegate: BCImagePickerControllerDelegate?
    
    public init() {
        let albumPicker = BCAlbumPickerController()
        super.init(rootViewController: albumPicker)
        
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
        checkPhotoAuth()
        
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
                        title: NSLocalizedString("Access restricted", comment: "to the photo library"),
                        message: NSLocalizedString("This application needs access to your photo library but it seems that you're not authorized to grant this permission.  Please contact someone who has higher privileges on the device.", comment: ""),
                        delegate: self,
                        cancelButtonTitle: NSLocalizedString("OK", comment: "")
                    )
                    photoAuthAlert.show()
                })
            case .Denied:
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let photoAuthAlert = UIAlertView(
                        title: NSLocalizedString("Please allow access", comment: "to the photo library"),
                        message: NSLocalizedString("This application needs access to your photo library. Please go to Settings > Privacy > Photos and switch this application to ON", comment: ""),
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
