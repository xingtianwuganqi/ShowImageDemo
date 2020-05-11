//
//  UserInfoController.swift
//  swiftText
//
//  Created by jingjun on 2018/8/28.
//  Copyright © 2018年 景军. All rights reserved.
//

import UIKit

class UserInfoController: UIViewController {
    
    lazy var imageview : UIImageView = {
        let backview = UIImageView()
        backview.image = UIImage(named: "head.jpg")
        return backview
    }()
    
    lazy var backView : UIView = {
        let back = UIView()
        back.backgroundColor = .black
        return back
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setFrame()
        addPanGesture()
    }
    
    func setFrame() {
        let imgW = ScreenW
        let imgH = ScreenW * (self.imageview.image?.size.height ?? 0) / (self.imageview.image?.size.width ?? 0)
        let y = (ScreenH - imgH) / 2
        self.view.addSubview(self.backView)
        backView.frame = self.view.frame
        backView.addSubview(imageview)
        self.imageview.frame = CGRect(x: 0, y: y, width: imgW, height: imgH)
        
        print("Begin Frame: ",self.imageview.frame)
    }

    func addPanGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panRecognizerAction(pan:)))
        self.imageview.addGestureRecognizer(pan)
        self.imageview.isUserInteractionEnabled = true
        pan.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func panRecognizerAction(pan:UIPanGestureRecognizer) {
        let translation = pan.translation(in: self.imageview)
        if pan.state == .changed {
            self.imageview.center = CGPoint(x: self.imageview.center.x, y: self.imageview.center.y + translation.y)
            pan.setTranslation(.zero, in: self.view)
            print("Change Frame: ",self.imageview.frame)
//            let alphaScale = abs(imageview.center.y - ScreenH / 2)
//            print("alphaScale: ",alphaScale)
//            self.backView.backgroundColor = UIColor.black.withAlphaComponent((ScreenH - CGFloat(alphaScale)) / ScreenH)
        }else if pan.state == .ended {
            
            // 如果偏移量大于某个值，直接划走消失，否则回归原位
            if self.imageview.center.y > ScreenH / 2 + 100 {
                // 向下划走消失
                let imgW = ScreenW
                let imgH = ScreenW * (self.imageview.image?.size.height ?? 0) / (self.imageview.image?.size.width ?? 0)
                let y = (ScreenH - imgH) / 2

                UIView.animate(withDuration: 0.3) {
                    self.imageview.frame = CGRect(x: 0, y: ScreenH, width: imgW, height: imgH)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.imageview.frame = CGRect(x: 0, y: y, width: imgW, height: imgH)
                }
            }else if self.imageview.center.y < ScreenH / 2 - 100 {
                // 向上划走消失
                let imgW = ScreenW
                let imgH = ScreenW * (self.imageview.image?.size.height ?? 0) / (self.imageview.image?.size.width ?? 0)
                let y = (ScreenH - imgH) / 2

                UIView.animate(withDuration: 0.3) {
                    self.imageview.frame = CGRect(x: 0, y: -imgH , width: imgW, height: imgH)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.imageview.frame = CGRect(x: 0, y: y, width: imgW, height: imgH)
                }
            }else{
                print("Gesture Ended")
                let imgW = ScreenW
                let imgH = ScreenW * (self.imageview.image?.size.height ?? 0) / (self.imageview.image?.size.width ?? 0)
                let y = (ScreenH - imgH) / 2
                UIView.animate(withDuration: 0.3) {
                    self.imageview.frame = CGRect(x: 0, y: y, width: imgW, height: imgH)
                }
            }
            
        }
    }
}

extension UserInfoController : UIGestureRecognizerDelegate {
    // 只允许上下起作用
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panView = gestureRecognizer.view else {
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
}
