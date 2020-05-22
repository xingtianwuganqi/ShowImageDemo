//
//  ShowBigImgView.swift
//  App-720yun
//
//  Created by jingjun on 2019/1/8.
//  Copyright © 2019 720yun. All rights reserved.
//

import UIKit
import SDWebImage

public class ShowBigImgView: UIView {
    
    let ScreenW = UIScreen.main.bounds.size.width
    let ScreenH = UIScreen.main.bounds.size.height
    
    lazy var backBtn : UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(named: "back_white"), for: .normal)
        button.setImage(UIImage(named: "back_white"), for: .normal)
        return button
    }()
    
    lazy var backScroll : UIScrollView = {
        let view = UIScrollView.init()
        view.backgroundColor = .white
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    lazy var pageControl : UIPageControl = {
        let pageControl = UIPageControl.init()
        return pageControl
    }()
    
    
    lazy var loading : UILabel = {
        let label = UILabel()
        label.text = "图片加载中"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        label.isHidden = false
        return label
    }()
    
    var dismissCallBack: (() -> Void)?
    
    var urlArr : [String] = []
    var imgArr : [UIImage] = []
    ///URL初始化
    public init(urlArr: [String],number: Int) {
        super.init(frame: .zero)
        self.frame = CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH)
        self.backgroundColor = UIColor.black
        showUrlScroll(urlArr: urlArr, number: number)
    }
    
    private func showUrlScroll(urlArr: [String],number: Int) {
        self.urlArr = urlArr
        self.addSubview(backScroll)
        self.backScroll.delegate = self
        self.backScroll.frame = CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH)
        self.backScroll.backgroundColor = .black
        self.backScroll.contentSize = CGSize(width: CGFloat(urlArr.count) * ScreenW, height: ScreenH)
        
        for i in 0..<urlArr.count {
            let scroll = UIScrollView.init(frame: CGRect(x: CGFloat(i) * ScreenW, y: 0, width: ScreenW, height: ScreenH))
            scroll.delegate = self
            scroll.tag = i
            scroll.isPagingEnabled = false
            backScroll.addSubview(scroll)
            scroll.minimumZoomScale = 1.0
            scroll.maximumZoomScale = 4
            scroll.showsHorizontalScrollIndicator = false
            scroll.showsVerticalScrollIndicator = false
            
            let imageview = UIImageView()
            scroll.addSubview(imageview)
            
            imageview.sd_setImage(with: URL(string: urlArr[i]), placeholderImage: UIImage.imageWithColor(color: UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)), options: []) { (img, error, _, url) in
                guard img != nil else {
                    self.loading.isHidden = true
                    return
                }
                guard let width = img?.size.width else {
                    return
                }
                guard let height = img?.size.height else {
                    return
                }
                
                self.loading.isHidden = true
                let w = self.ScreenW
                let h = self.ScreenW / (width / height)
                
                if h > self.ScreenH {
                    let y = (h - self.ScreenH) / 2
                    scroll.contentSize = CGSize(width: self.ScreenW, height: h)
                    scroll.contentOffset = CGPoint(x: 0, y: y)
                    imageview.frame = CGRect(x: 0, y: 0, width: w, height: h)
                }else{
                    let y = (self.ScreenH - h) / 2
                    imageview.frame = CGRect(x: 0, y: y, width: w, height: h)
                }
            }
            imageview.tag = 100 + i
            
            self.addTapGesture(imageview: imageview, scroll: scroll)
            
            self.addPanGesture(imageview)
        }
        self.addSubview(loading)
        //        self.addSubview(downloadBtn)
        self.addSubview(backBtn)
        
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        //        downloadBtn.addTarget(self, action: #selector(downloadImage), for: .touchUpInside)
        
        self.backScroll.contentOffset.x = CGFloat(number) * ScreenW
        setPageControl(urlArr.count, current: number)
        setUI()
        
    }
    
    public init(_ Images: [UIImage],number: Int) {
        super.init(frame: .zero)
        
        self.frame = CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH)
        self.backgroundColor = UIColor.black
        
        self.showImages(Images: Images, number: number)
    }
    
    private func showImages(Images: [UIImage],number: Int) {
        self.imgArr = Images
        self.addSubview(backScroll)
        self.backScroll.delegate = self
        self.backScroll.frame = CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH)
        self.backScroll.backgroundColor = .black
        self.backScroll.contentSize = CGSize(width: CGFloat(Images.count) * ScreenW, height: ScreenH)
        
        for i in 0..<Images.count {
            let scroll = UIScrollView.init(frame: CGRect(x: CGFloat(i) * ScreenW, y: 0, width: ScreenW, height: ScreenH))
            scroll.delegate = self
            scroll.tag = i
            scroll.isPagingEnabled = false
            backScroll.addSubview(scroll)
            scroll.minimumZoomScale = 1.0
            scroll.maximumZoomScale = 4
            scroll.showsHorizontalScrollIndicator = false
            scroll.showsVerticalScrollIndicator = false
            
            let imageview = UIImageView()
            scroll.addSubview(imageview)
            
            let imageV = Images[i]
            
            imageview.image = imageV
            
            let w = ScreenW
            let h = ScreenW / (imageV.size.width / imageV.size.height)
            
            if h > ScreenH {
                let y = (h - ScreenH) / 2
                scroll.contentSize = CGSize(width: ScreenW, height: h)
                scroll.contentOffset = CGPoint(x: 0, y: y)
                imageview.frame = CGRect(x: 0, y: 0, width: w, height: h)
            }else{
                let y = (ScreenH - h) / 2
                imageview.frame = CGRect(x: 0, y: y, width: w, height: h)
            }
            
            imageview.tag = 100 + i
            
            self.addTapGesture(imageview: imageview, scroll: scroll)
            
            self.addPanGesture(imageview)
        }
        self.addSubview(loading)
        loading.isHidden = true
        //        self.addSubview(downloadBtn)
        
        self.addSubview(backBtn)
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        //        downloadBtn.addTarget(self, action: #selector(downloadImage), for: .touchUpInside)
        self.backScroll.contentOffset.x = CGFloat(number) * ScreenW
        setPageControl(imgArr.count, current: number)
        setUI()
    }
    
    
    /// 弹出动画
    func pushAnimation(num: Int) {
        
        // 获取UIImageView()
        guard let imageView = self.backScroll.viewWithTag(100 + num) as?  UIImageView else {
            return
        }
        transformAnimation(animationView: imageView)
        
    }
    
    private func setUI() {
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 5).isActive = true
        backBtn.topAnchor.constraint(equalTo: self.topAnchor,constant: 44).isActive = true
        backBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        loading.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    private func setPageControl(_ total: Int,current: Int) {
        self.addSubview(self.pageControl)
        self.pageControl.frame = CGRect(x: 0, y: ScreenH - 80, width: ScreenW, height: 30)
        self.pageControl.numberOfPages = total
        self.pageControl.currentPage = current
        self.pageControl.currentPageIndicatorTintColor = UIColor.white
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.hidesForSinglePage = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backBtnClick()
    }
}
// MARK: 点击的方法
extension ShowBigImgView {
    
    @objc func backBtnClick() {
        self.removeAnimation()
    }
    
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
    
    @objc func viewClick(tap:UITapGestureRecognizer) {
        self.backBtnClick()
    }
    
    func zoomRectForScale(scrollview: UIScrollView, scale: CGFloat,center: CGPoint) -> CGRect {
        var zoomRect: CGRect = CGRect()
        zoomRect.size.height = scrollview.frame.size.height / scale
        zoomRect.size.width = scrollview.frame.size.width / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    @objc func downloadImage() {
        
        let offsetX = self.backScroll.contentOffset.x
        let tagValue = offsetX / ScreenW
        guard let imageview = self.backScroll.viewWithTag(Int(tagValue))?.viewWithTag(100 + Int(tagValue)) as? UIImageView else{
            return
        }
        
        guard let img = imageview.image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(img, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
}

//MARK: UIScrollViewDelegate
extension ShowBigImgView : UIScrollViewDelegate {
    // 当scrollview 尝试进行缩放的时候
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        let offsetX = self.backScroll.contentOffset.x
        let tagValue = offsetX / ScreenW
        return self.backScroll.viewWithTag(Int(tagValue))?.viewWithTag(100 + Int(tagValue))
    }
    
    // 当缩放完毕的时候调用
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
    // 将要开始缩放
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        
    }
    
    // 当正在缩放的时候
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
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
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.backScroll {
            let offsetX = self.backScroll.contentOffset.x
            let tagValue = offsetX / ScreenW
            self.pageControl.currentPage = Int(tagValue)
        }
    }
    
}
//MARK: 动画
extension ShowBigImgView {
    // 缩放动画
    func transformAnimation(animationView: UIImageView) {
        let animation: CABasicAnimation = CABasicAnimation()
        animation.keyPath = "transform.scale"
        animation.fromValue = 0.2 // 原始系数
        animation.toValue = 1 // 缩放系数
        animation.duration = 0.3
        animation.isRemovedOnCompletion = true
        animation.fillMode = CAMediaTimingFillMode.removed
        animationView.layer.add(animation, forKey: nil)
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
        scale.fillMode = CAMediaTimingFillMode.forwards
        scale.isRemovedOnCompletion = false
        imageView.layer.add(scale, forKey: nil)
        
        let backAnimation = CAKeyframeAnimation()
        backAnimation.delegate = self
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
        backAnimation.fillMode = CAMediaTimingFillMode.forwards
        backAnimation.isRemovedOnCompletion = false
        self.layer.add(backAnimation, forKey: nil)
        
    }
    
    // 背景变淡消失的动画
    func backRemoveAnimation(_ duration: CFTimeInterval) {
        let backAnimation = CAKeyframeAnimation()
        backAnimation.delegate = self
        backAnimation.keyPath = "opacity"
        backAnimation.duration = duration
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
        backAnimation.fillMode = CAMediaTimingFillMode.forwards
        backAnimation.isRemovedOnCompletion = false
        self.layer.add(backAnimation, forKey: nil)
    }
    
}
// MARK: 动画代理
extension ShowBigImgView: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim.isKind(of: CAKeyframeAnimation.self) && flag {
            self.dismissCallBack?()
        }
    }
}

extension ShowBigImgView : UIAlertViewDelegate {
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            if error.localizedDescription == "数据不可用" {
                print(error.localizedDescription)
            }else{
                print(error.localizedDescription)
            }
        } else {
            print("保存到相册")
        }
    }
}

// MARK: 添加手势
extension ShowBigImgView: UIGestureRecognizerDelegate {
    // 点击手势
    func addTapGesture(imageview: UIImageView,scroll: UIScrollView) {
        imageview.isUserInteractionEnabled = true
        scroll.isUserInteractionEnabled = true
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(imageClick(tap:)))
        doubleTap.numberOfTapsRequired = 2
        imageview.addGestureRecognizer(doubleTap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewClick(tap:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        imageview.addGestureRecognizer(tap)
        scroll.addGestureRecognizer(tap)
        
        tap.require(toFail: doubleTap)
    }
    // 拖动手势
    func addPanGesture(_ imgView: UIView) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panRecognizerAction(pan:)))
        imgView.addGestureRecognizer(pan)
        imgView.isUserInteractionEnabled = true
        pan.delegate = self
    }
    
    @objc func panRecognizerAction(pan:UIPanGestureRecognizer) {
        guard let imageview = pan.view else {
            return
        }
        guard let imgSuperView = imageview.superview else {
            return
        }
        let translation = pan.translation(in: imageview)
        if pan.state == .changed {
            imageview.center = CGPoint(x: imageview.center.x, y: imageview.center.y + translation.y)
            pan.setTranslation(.zero, in: imgSuperView)
            print("Change Frame: ",imageview.frame)
            // 滑动时改变背景透明度
            //            let alphaScale = abs(imageview.center.y - ScreenH / 2)
            //            print("alphaScale: ",alphaScale)
            //            self.backView.backgroundColor = UIColor.black.withAlphaComponent((ScreenH - CGFloat(alphaScale)) / ScreenH)
        }else if pan.state == .ended {
            
            // 如果偏移量大于某个值，直接划走消失，否则回归原位
            if imageview.center.y > ScreenH / 2 + 50 {
                self.imagePanRemoveAnimation(false, imageview: imageview)
            }else if imageview.center.y < ScreenH / 2 - 50 {
                self.imagePanRemoveAnimation(true, imageview: imageview)
            }else{
                // 回复原位
                let imgW = ScreenW
                let imgH = ScreenW * (imageview.frame.size.height) / (imageview.frame.size.width)
                let y = (ScreenH - imgH) / 2
                UIView.animate(withDuration: 0.3) {
                    imageview.frame = CGRect(x: 0, y: y, width: imgW, height: imgH)
                }
            }
            
        }
    }
    
    // 只允许上下起作用
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panView = gestureRecognizer.view else {
            return false
        }
        // 正在缩放的view，不支持手势
        guard panView.frame.size.width == self.ScreenW else{
            return false
        }
        // 长图不支持
        guard panView.frame.size.height <= ScreenH else{
            return false
        }
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            let panGesture = gestureRecognizer as! UIPanGestureRecognizer
            let offset = panGesture.translation(in: panView)
            if offset.x == 0 && offset.y != 0 {
                return true
            }
        }
        
        return false
    }
    
    func imagePanRemoveAnimation(_ isTop: Bool,imageview: UIView) {
        let duration = 0.4
        if isTop {
            // 向上划走消失
            let imgW = ScreenW
            let imgH = ScreenW * (imageview.frame.size.height) / (imageview.frame.size.width)
            
            UIView.animate(withDuration: duration) {
                imageview.frame = CGRect(x: 0, y: -imgH , width: imgW, height: imgH)
            }
            
            self.backRemoveAnimation(duration)
        }else{
            // 向下划走消失
            let imgW = ScreenW
            let imgH = ScreenW * (imageview.frame.size.height) / (imageview.frame.size.width)
            
            UIView.animate(withDuration: duration) {
                imageview.frame = CGRect(x: 0, y: self.ScreenH, width: imgW, height: imgH)
            }
            
            self.backRemoveAnimation(duration)
        }
    }
}

extension UIImage {
    static func imageWithColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? nil
    }
}
