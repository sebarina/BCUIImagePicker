//
//  UTAssetCollectionController.swift
//  UTeacher
//
//  Created by Sebarina Xu on 1/18/16.
//  Copyright © 2016 liufan. All rights reserved.
//

import UIKit
import Photos

public class BCAssetCollectionController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var collectionView : UICollectionView?
    var assetCollection : PHAssetCollection?
    var assets : [PHAsset] = []
  
    var maximumNumber : Int = 0
    
    let padding : CGFloat = 5
    var cellWidth : CGFloat = 100
    let cellIdentifier : String = "CollectionCellIdentifier"
    var cellSelected : [Bool] = []
    var selectedCount : Int = 0
    var selectedAssets : [PHAsset] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = true
        // Do any additional setup after loading the view.
        title = assetCollection?.localizedTitle ?? "照片卷"
        maximumNumber = (navigationController as? BCImagePickerController)?.appearance.maxSelectNumber ?? 0
        
        cellWidth = (view.frame.width - padding*5)/4
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        
        collectionView = UICollectionView(frame: CGRectMake(0, 0, view.frame.width, view.frame.height), collectionViewLayout: layout)
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        view.addSubview(collectionView!)
        performSelectorInBackground(#selector(BCAssetCollectionController.preparePhotos), withObject: nil)
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let okButton = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: #selector(self.selectImages))
        okButton.tintColor = (navigationController as? BCImagePickerController)?.appearance.titleColor
        self.navigationItem.rightBarButtonItem = okButton
        if let customImage = (navigationController as? BCImagePickerController)?.appearance.customBackImage {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: customImage, style: .Plain, target: self, action: #selector(self.back))
        }
    }
    
    func back() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func preparePhotos() {
        let option = PHFetchOptions()
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        option.sortDescriptors = [sort]
        PHAsset.fetchAssetsInAssetCollection(assetCollection!, options: option).enumerateObjectsUsingBlock {(obj, index, error) in
            if let asset = obj as? PHAsset {
                self.assets.append(asset)
                self.cellSelected.append(false)
            }
        }
        dispatch_async(dispatch_get_main_queue()) { 
            self.collectionView?.reloadData()
        }
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        var imageView = cell.viewWithTag(100) as? UIImageView
        if imageView == nil  {
            imageView = UIImageView(frame: CGRectMake(0,0,cellWidth,cellWidth))
            imageView?.contentMode = UIViewContentMode.ScaleAspectFill
            imageView?.clipsToBounds = true
            imageView?.tag = 100
            cell.contentView.addSubview(imageView!)
        }
        let data : PHAsset = assets[indexPath.row]
        
        imageView?.loadImageFromAsset(data)
        
        if cell.viewWithTag(101) == nil {
            let tempView = UIView(frame: CGRectMake(0,0,cellWidth,cellWidth))
            tempView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
            tempView.tag = 101
            let icon = UIImageView(frame: CGRectMake((cellWidth - 24)/2, (cellWidth - 24)/2, 24, 24))
            icon.image = (navigationController as? BCImagePickerController)?.appearance.imageSelectedIcon
            tempView.addSubview(icon)
            cell.contentView.addSubview(tempView)
        }
        
        if cellSelected[indexPath.row] {
            cell.viewWithTag(101)?.hidden = false
        } else {
            cell.viewWithTag(101)?.hidden = true
        }
            
        return cell
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: 20, right: padding)
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return padding
        
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return padding
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        if cell == nil {
            return
        }
        
        if cellSelected[indexPath.row] {
            cellSelected[indexPath.row] = false
            cell!.viewWithTag(101)?.hidden = true
            selectedCount -= 1
            
            let index = selectedAssets.indexOf(assets[indexPath.row])
            
            if index != nil {
                selectedAssets.removeAtIndex(index!)
            }
            
        } else {
            if selectedCount < maximumNumber {
                cellSelected[indexPath.row] = true
                cell!.viewWithTag(101)?.hidden = false
                selectedCount += 1
                selectedAssets.append(assets[indexPath.row])
            } else {
                UIAlertView(title: "",
                            message: "你你最多只能选择\(maximumNumber)张照片",
                            delegate: nil,
                            cancelButtonTitle: "我知道了").show()
                
            }
            
        }
        if selectedCount == 0 {
            self.navigationItem.rightBarButtonItem?.title = "取消"
            
        } else {
            self.navigationItem.rightBarButtonItem?.title = "完成"
            
        }
    }
    
    func selectImages() {
        (navigationController as? BCImagePickerController)?.selectedAssets(selectedAssets)
                    
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
 

}
