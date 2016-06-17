//
//  ViewController.swift
//  BCImagePickerDemo
//
//  Created by Sebarina Xu on 6/16/16.
//  Copyright © 2016 forzadata. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, BCImagePickerControllerDelegate {

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    var images : [UIImageView] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        images = [imageView1, imageView2, imageView3]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    @IBAction func pick(sender: AnyObject) {
    
        let vc = BCImagePickerController()
        vc.appearance.navBarColor = UIColor.purpleColor()
        vc.appearance.titleColor = UIColor.whiteColor()
        vc.appearance.customBackImage = UIImage(named: "Nav-返回")
        vc.imagePickerDelegate = self
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func didFinishedPickImages(picker: BCImagePickerController, selectedAssets: [PHAsset]) {
        for i in 0 ..< selectedAssets.count {
            let asset = selectedAssets[i]
            let scale = UIScreen.mainScreen().scale
            PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(scale*80, scale*80), contentMode: .AspectFill, options: nil, resultHandler: { [weak self](image, info) in
                self?.images[i].image = image
            })
            
        }
        
    }

}

