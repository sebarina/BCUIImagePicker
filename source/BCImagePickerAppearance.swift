//
//  BCImagePickerAppearance.swift
//  BCImagePickerDemo
//
//  Created by Sebarina Xu on 6/17/16.
//  Copyright © 2016 forzadata. All rights reserved.
//

import UIKit


public struct BCImagePickerAppearance {
    /// 导航栏背景颜色配置
    public var navBarColor : UIColor = UIColor.whiteColor()
    public var titleColor : UIColor = UIColor.blackColor()
    /// 最多支持选中多少张图片
    public var maxSelectNumber : Int = 3
    /// 自定义返回按钮
    public var customBackImage : UIImage?
    /// 图片选中时的图片
    public var imageSelectedIcon : UIImage! = UIImage(named: "icon_checked")
    
}