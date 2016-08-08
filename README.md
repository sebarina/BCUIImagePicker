# BCUIImagePicker
Image picker library, support multiple selection。
基于photokit的framework。

### PHAsset & ALAsset：
iOS 8之前，使用ALAsset， iOS 8之后，出现了PhotoKit，一个可以让应用更好地与设备照片库对接的框架。

### PhotoKit的基本构成：
- PHAsset: 代表照片库中的一个资源，跟 ALAsset 类似，通过 PHAsset 可以获取和保存资源
- PHFetchOptions: 获取资源时的参数，可以传 nil，即使用系统默认值
- PHAssetCollection: PHCollection 的子类，表示一个相册或者一个时刻，或者是一个「智能相册（系统提供的特定的一系列相册，例如：最近删除，视频列表，收藏等等，如下图所示）
- PHAssetCollectionList: 表示一组PHCollection，它本身也是一个PHCollection，因此PHCollection 作为一个集合，可以包含其他集合
- PHFetchResult: 表示一系列的资源结果集合，也可以是相册的集合，从?PHCollection 的类方法中获得
- PHImageManager: 用于处理资源的加载，加载图片的过程带有缓存处理，可以通过传入一个 PHImageRequestOptions 控制资源的输出尺寸等规格
- PHImageRequestOptions: 如上面所说，控制加载图片时的一系列参数

### 使用方式
(1) 创建image picker
<pre>
	static func multipleImagePicker(maxSelectNumber: Int) -> BCImagePickerController {
        let picker = BCImagePickerController()
        var appearance = BCImagePickerAppearance()
        appearance.navBarColor = ColorConstant.basicGreen
        appearance.titleColor = UIColor.whiteColor()
        appearance.customBackImage = UIImage(named: "Nav-返回")
        appearance.imageSelectedIcon = UIImage(named: "icon_selected")
        appearance.maxSelectNumber = maxSelectNumber
        picker.appearance = appearance
        return picker
    }
</pre>
（2）present image picker controller
<pre>
let picker = ImagePickerUtil.multipleImagePicker(number)
picker.imagePickerDelegate = self
presentViewController(picker, animated: true, completion: nil)
</pre>
（3）实现delegate方法
<pre>
func didFinishedPickImages(picker: BCImagePickerController, selectedAssets: [PHAsset]) {

}
</pre>

### 运行效果图
![1](http://utility.uteacher.me/imagepicker2.jpg)
![2](http://utility.uteacher.me/imagepicker1.jpg)

