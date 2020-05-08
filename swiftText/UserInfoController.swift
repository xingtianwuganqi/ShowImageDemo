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


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setFrame()
    }
    
    func setFrame() {
        let imgW = ScreenW
        let imgH = ScreenW * (self.imageview.image?.size.height ?? 0) / (self.imageview.image?.size.width ?? 0)
        let y = (ScreenH - imgH) / 2
        self.view.addSubview(self.imageview)
        self.imageview.frame = CGRect(x: 0, y: y, width: imgW, height: imgH)
    }

    func addPanGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panRecognizerAction(pan:)))
        self.imageview.addGestureRecognizer(pan)
        pan.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func panRecognizerAction(pan:UIPanGestureRecognizer) {
        
    }

    

}

extension UserInfoController : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
}
