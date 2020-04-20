//
//  ShowBigImgController.swift
//  rebate
//
//  Created by jingjun on 2020/4/20.
//  Copyright © 2020 寻宝天行. All rights reserved.
//

import UIKit

class ShowBigImgController: UIViewController {
    
    private var showView: ShowBigImgView?
    private var number: Int
    init(imgs: [String],img: String) {
        var number = 0
        _ = imgs.enumerated().map { (index,urlStr) in
            if urlStr == img {
                number = index
            }
        }
        self.number = number
        self.showView = ShowBigImgView(urlArr: imgs,number: number)
        super.init(nibName: nil, bundle: nil)
    }
    
    init(urls: [String],url: String) {
        var number = 0
        _ = urls.enumerated().map { (index,urlStr) in
            if urlStr == url {
                number = index
            }
        }
        self.number = number
        self.showView = ShowBigImgView.init(urlArr: urls, number: number)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.view.addSubview(self.showView!)
        
        self.showView?.dismissCallBack = { [weak self] in
            self?.dismiss(animated: false, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showView?.pushAnimation(num: self.number)
    }
    
    deinit {
        print("ShowController Deinit")
    }
}
