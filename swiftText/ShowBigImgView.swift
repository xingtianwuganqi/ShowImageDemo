//
//  ShowBigImgView.swift
//  App-720yun
//
//  Created by jingjun on 2019/1/8.
//  Copyright © 2019 720yun. All rights reserved.
//

import UIKit
import RxSwift
import SwifterSwift

class ShowBigImgView: UIView {
    
    let backBtn = UIButton(type: .custom).then { (button) in
        button.setImage(UIImage(named: "back_white"), for: .normal)
        button.setImage(UIImage(named: "back_white"), for: .normal)
    }

    
    let backScroll = UIScrollView().then { (view) in
        view.backgroundColor = .white
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
    }
    
    let numberLab = UILabel().then { (label) in
        label.textColor = .white
        label.font = UIFont.init(name: Medium, size: 14)
    }
    
    let downloadBtn = UIButton(type: .custom).then { (button) in
        button.setImage(UIImage(named: "upload_download"), for: .normal)
        button.setTitle("保存到相册", for: .normal)
        button.titleLabel?.font = UIFont.init(name: Medium, size: 14)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
    }
    
    let loading = UILabel().then { (label) in
        label.text = "图片加载中"
        label.textColor = UIColor.white
        label.font = UIFont.init(name: Bold, size: 14)
        label.isHidden = false
    }
    
    var urlArr : [String] = []
    var imgArr : [UIImage] = []
    init(urlArr: [String],number: Int) {
        super.init(frame: .zero)
        
        self.frame = CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH)
        self.backgroundColor = UIColor.black
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
            
            imageview.sd_setImage(with: URL(string: urlArr[i]), placeholderImage: UIImage.imageWithColor(color: UIColor(hexString: "#000000")!), options: []) { (img, error, _, url) in
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
                let w = ScreenW
                let h = ScreenW / (width / height)
                let y = (ScreenH - h) / 2
                imageview.frame = CGRect(x: 0, y: y, width: w, height: h)
            }
            imageview.tag = 100 + i
            
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
        self.addSubview(numberLab)
        self.addSubview(downloadBtn)
        
        self.addSubview(backBtn)
        
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        downloadBtn.addTarget(self, action: #selector(downloadImage), for: .touchUpInside)
        
        self.backScroll.contentOffset.x = CGFloat(number) * ScreenW
        self.numberLab.text = "\(number + 1)/\(urlArr.count)"
        
    }
    
    init(_ Images: [UIImage],number: Int) {
        super.init(frame: .zero)
        
        self.frame = CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH)
        self.backgroundColor = UIColor.black
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
            let y = (ScreenH - h) / 2
            
            imageview.frame = CGRect(x: 0, y: y, width: w, height: h)
    
            imageview.tag = 100 + i
            
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
        self.addSubview(numberLab)
        self.addSubview(downloadBtn)
        
        self.addSubview(backBtn)
        
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        downloadBtn.addTarget(self, action: #selector(downloadImage), for: .touchUpInside)
        
        self.backScroll.contentOffset.x = CGFloat(number) * ScreenW
        self.numberLab.text = "\(number + 1)/\(Images.count)"
    
    }
    
    func show(number:Int) {
        UIApplication.shared.keyWindow?.addSubview(self)
        self.pushAnimation(num: number)
    }
    
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

    
    override func layoutSubviews() {
        super.layoutSubviews()
        backBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(44)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        numberLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-20)
            } else {
                make.bottom.equalToSuperview().offset(-20)
            }
        }
        
        downloadBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(numberLab)
            make.size.equalTo(CGSize(width: 85, height: 20))
        }
        
//        loading.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.centerX.equalToSuperview()
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backBtnClick()
    }
    
    @objc func backBtnClick() {
        
        self.removeAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.removeFromSuperview()
        }
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
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            if error.localizedDescription == "数据不可用" {
                openSystemSettingPhotoLibrary(type: "add")
            }else{
                
                printLog(message: error.localizedDescription)
            }
        } else {
            printLog(message: "已保存到本地相册")
        }
    }
    
    func openSystemSettingPhotoLibrary(type:String) {
        var destri = ""
        if type == "add" {
            destri = "加入"
        }else{
            destri = "访问"
        }
        
        
        let alertView = UIAlertView(title: "未获得权限访问您的照片", message: "请在设置选项中允许720yun\(destri)您的照片", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "去设置")
        alertView.show()
    }
}
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.backScroll {
            let offsetX = self.backScroll.contentOffset.x
            let tagValue = offsetX / ScreenW
            if urlArr.count == 0 {
                self.numberLab.text = "\(Int(tagValue) + 1)/\(imgArr.count)"
            }else{
                self.numberLab.text = "\(Int(tagValue) + 1)/\(urlArr.count)"
            }
        }
    }
        
}
extension ShowBigImgView : UIAlertViewDelegate {
//    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
//        let btnTitle = alertView.buttonTitle(at: buttonIndex)
//        if btnTitle == "取消" {
//            alertView.dismiss(withClickedButtonIndex: buttonIndex, animated: true)
//        }else if btnTitle == "去设置" {
//            let url=URL.init(string: UIApplication.openSettingsURLString)
//
//            if UIApplication.shared.canOpenURL(url!){
//
//                UIApplication.shared.open(url!, options: [:], completionHandler: { (ist) in
//
//                })
//            }
//        }
//    }
}
