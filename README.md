# ShowImageDemo
图片浏览控件
### 仿微信朋友圈查看图片功能
##### 效果图：
![download](https://github.com/xingtianwuganqi/ShowImageDemo/blob/master/RPReplay.gif)

## 实现思路
scrollView 具有放大缩小的功能，实现图片的放大与缩小的思路就是将imageView放在scrollView上，双击时调用scrollView的
```
@available(iOS 3.0, *)
    open func zoom(to rect: CGRect, animated: Bool)
```
来实现imageView的放大与缩小

## 实现步骤
1.两个初始化方法
```
// 通过图片url数组初始化
init(urlArr: [String],number: Int)

// 通过图片数组初始化
init(_ Images: [UIImage],number: Int)
```
在初始化方法中初始化backScrollView 和承载imageView的scrollView,并给imageView和scrollView添加点击手势

2.承载imageView的scrollView设置代理方法
```
extension ShowBigImgView : UIScrollViewDelegate {
    // 当scrollview 尝试进行缩放的时候
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        let offsetX = self.backScroll.contentOffset.x
        let tagValue = offsetX / ScreenW
        return self.backScroll.viewWithTag(Int(tagValue))?.viewWithTag(100 + Int(tagValue))
    }
    
    // 当缩放完毕的时候调用
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        printLog(message: "缩放结束-\(scale)")
    }
    
    // 当正在缩放的时候
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        printLog(message: "正在缩放")
        
        let offsetX = self.backScroll.contentOffset.x
        let tagValue = offsetX / ScreenW
        
        //获取到这个scrollview
        var centerX = self.backScroll.center.x
        var centerY = self.backScroll.center.y
        
        centerX = scrollView.contentSize.width > scrollView.frame.size.width ?
            scrollView.contentSize.width/2:centerX
        centerY = scrollView.contentSize.height > scrollView.frame.size.height ?
            scrollView.contentSize.height/2:centerY
        scrollView.viewWithTag(100 + Int(tagValue))?.center = CGPoint(x: centerX, y: centerY)
    }
}
```
3.图片的点击放大手势
```
    @objc func imageClick(tap:UITapGestureRecognizer) {
        
        var newscale : CGFloat = 0
        
        guard let scroll = tap.view?.superview as? UIScrollView else {
            return
        }
        
        if scroll.zoomScale == 1.0 {
            newscale = 3
        }else {
            newscale = 1.0
        }
        
        let zoomRect = self.zoomRectForScale(scrollview: scroll,scale: newscale, center: tap.location(in: tap.view))
        
        scroll.zoom(to: zoomRect, animated: true)
    }
// 计算放大或缩小的frame
    func zoomRectForScale(scrollview: UIScrollView, scale: CGFloat,center: CGPoint) -> CGRect {
        var zoomRect: CGRect = CGRect()
        zoomRect.size.height = scrollview.frame.size.height / scale
        zoomRect.size.width = scrollview.frame.size.width / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
```
4.出现时的动画
```
    func pushAnimation(num: Int) {
        // 获取UIImageView()
        guard let imageView = self.backScroll.viewWithTag(100 + num) as?  UIImageView else {
            return
        }
        transformAnimation(animationView: imageView)
    }
// 缩放动画
    func transformAnimation(animationView: UIImageView) {
        let animation: CABasicAnimation = CABasicAnimation()
        animation.keyPath = "transform.scale"
        animation.fromValue = 0.2 // 原始系数
        animation.toValue = 1 // 缩放系数
        animation.duration = 0.3
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeRemoved
        animationView.layer.add(animation, forKey: nil)
    }
```
5.消失时的动画
```
    @objc func backBtnClick() {
        self.removeAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.removeFromSuperview()
        }
    }

// 缩放 + 淡入淡出
    func removeAnimation() {
        
        let x = Int(self.backScroll.contentOffset.x)
        let y = Int(ScreenW)
        guard (x % y) == 0 else{
            return
        }
        // 获取
        let tag = x / y + 100
        guard let imageView = self.backScroll.viewWithTag(tag) else {
            return
        }        
        let scale = CABasicAnimation()
        scale.keyPath = "transform.scale"
        scale.fromValue = 1.0
        scale.toValue = 0.2
        scale.duration = 0.3
        scale.fillMode = kCAFillModeForwards
        scale.isRemovedOnCompletion = false
        imageView.layer.add(scale, forKey: nil)

        let backAnimation = CAKeyframeAnimation()
        backAnimation.keyPath = "opacity"
        backAnimation.duration = 0.4
        backAnimation.values = [
            NSNumber(value: 0.90 as Float),
            NSNumber(value: 0.60 as Float),
            NSNumber(value: 0.30 as Float),
            NSNumber(value: 0.0 as Float),
        ]
        backAnimation.keyTimes = [
            NSNumber(value: 0.1),
            NSNumber(value: 0.2),
            NSNumber(value: 0.3),
            NSNumber(value: 0.4)
        ]
        backAnimation.fillMode = kCAFillModeForwards
        backAnimation.isRemovedOnCompletion = false
        self.layer.add(backAnimation, forKey: nil)
    }
```
6.调用
```
    func showImg (imgs: [String],url: String) {
        var number = 0
        _ = imgs.enumerated().map { (index,urlStr) in
            if urlStr == url {
                number = index
            }
        }
        
        let show = ShowBigImgView(urlArr: imgs,number: number)
        show.show(number: number)
    }
```

