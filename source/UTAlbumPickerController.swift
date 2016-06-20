//
//  UTAlbumPickerController.swift
//  UTeacher
//
//  Created by Sebarina Xu on 1/18/16.
//  Copyright © 2016 liufan. All rights reserved.
//

import UIKit
import Photos

public class BCAlbumPickerController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView : UITableView?
    let cellIdentifier : String = "TableCellIdentifier"

    var assetCollections : [PHAssetCollection] = []

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "照片"
        tableView = UITableView(frame: CGRectMake(0, 0, view.frame.width, view.frame.height), style: UITableViewStyle.Plain)
        tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView?.separatorStyle = .SingleLine
        tableView?.separatorColor = UIColor(red: 200.0/255.0, green: 199.0/255.0, blue: 204.0/255.0, alpha: 1)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.tableFooterView = UIView()
        view.addSubview(tableView!)
        performSelectorInBackground(#selector(self.prepareAlbums), withObject: nil)
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
        
    }
    
    deinit {
        PHPhotoLibrary.sharedPhotoLibrary().unregisterChangeObserver(self)
    }
    
    func prepareAlbums() {
        let option = PHFetchOptions()
        option.predicate = NSPredicate(format: "estimatedAssetCount > 0")
        let result = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: option)
        result.enumerateObjectsUsingBlock { (collection, index, error) in
            if let album = collection as? PHAssetCollection {
                self.assetCollections.append(album)
            }
        }
        
        PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .SmartAlbumUserLibrary, options: nil).enumerateObjectsUsingBlock({ (collection, index, error) in
            if let album = collection as? PHAssetCollection {
                self.assetCollections.append(album)
            }
        })
        PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .SmartAlbumRecentlyAdded, options: nil).enumerateObjectsUsingBlock({ (collection, index, error) in
            if let album = collection as? PHAssetCollection {
                self.assetCollections.append(album)
            }
        })
        
        if #available(iOS 9.0, *) {
            PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .SmartAlbumScreenshots, options: nil).enumerateObjectsUsingBlock({ (collection, index, error) in
                if let album = collection as? PHAssetCollection {
                    self.assetCollections.append(album)
                }
            })
        } 
        
        dispatch_async(dispatch_get_main_queue()) { 
            self.tableView?.reloadData()
        }
        
    }
    
    
    
    public override func viewWillAppear(animated: Bool) {
        let cancelButton = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: #selector(self.close))
        cancelButton.tintColor = (navigationController as? BCImagePickerController)?.appearance.titleColor
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    func close() {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let collection : PHAssetCollection = assetCollections[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.backgroundColor = UIColor.whiteColor()
        
        let groupName : String = collection.localizedTitle ?? "照片流"
        
        
        var cellImageView = cell.viewWithTag(100) as? UIImageView
        if cellImageView == nil {
            cellImageView = UIImageView(frame: CGRectMake(20, 20, 80, 80))
            cellImageView?.contentMode = UIViewContentMode.ScaleAspectFill
            cellImageView?.clipsToBounds = true
            cellImageView?.tag = 100
            cell.contentView.addSubview(cellImageView!)
        }
        var label = cell.viewWithTag(101) as? UILabel
        if label == nil {
            label = UILabel(frame: CGRectMake(120, 0, tableView.frame.width - 140, 120))
            label?.textColor = UIColor.blackColor()
            label?.textAlignment = .Left
            label?.font = UIFont.systemFontOfSize(16)
            label?.tag = 101
            cell.contentView.addSubview(label!)
        }
        
        let result =  PHAsset.fetchAssetsInAssetCollection(collection, options: nil)
        
        if collection.assetCollectionType == .SmartAlbum {
            label?.text = "\(groupName) (\(result.count))"
        } else {
            label?.text = "\(groupName) (\(collection.estimatedAssetCount))"
        }
        
        if let asset = result.firstObject as? PHAsset {
//            cellImageView?.loadImageFromAsset(asset)
            let scale = UIScreen.mainScreen().scale
            PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(80*scale, 80*scale), contentMode: .AspectFill , options: nil) { ( image, info) in
                cellImageView?.image = image
            }
            
        } else {
            cellImageView?.image = UIImage(named: "Placeholder")
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetCollections.count
       
    }
    
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let collection = assetCollections[indexPath.row]
        let assetPicker = BCAssetCollectionController()
        assetPicker.assetCollection = collection       
        navigationController?.pushViewController(assetPicker, animated: true)
    }
    
  
}

extension BCAlbumPickerController : PHPhotoLibraryChangeObserver {
    public func photoLibraryDidChange(changeInstance: PHChange) {
        prepareAlbums()
    }
}
