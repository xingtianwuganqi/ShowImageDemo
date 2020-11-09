//
//  ShowBigImgController.swift
//  rebate
//
//  Created by jingjun on 2020/4/20.
//  Copyright © 2020 寻宝天行. All rights reserved.
//

import UIKit

public class ShowBigImgController: UIViewController {
    
    internal var showView: ShowBigImgBackView?
    internal var number: Int
    public init(imgs: [UIImage],img: UIImage) {
        var number = 0
        _ = imgs.enumerated().map { (index,urlStr) in
            if urlStr == img {
                number = index
            }
        }
        self.number = number
        self.showView = ShowBigImgBackView(imgArr: imgs, number: number)
        super.init(nibName: nil, bundle: nil)
    }
    
    public init(urls: [String],url: String) {
        var number = 0
        _ = urls.enumerated().map { (index,urlStr) in
            if urlStr == url {
                number = index
            }
        }
        self.number = number
        self.showView = ShowBigImgBackView.init(urlArr: urls, number: number)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.view.addSubview(self.showView!)
        
        self.showView?.dismissCallBack = { [weak self] in
            self?.dismiss(animated: false, completion: nil)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showView?.transformAnimation(num: self.number)
    }
    
    deinit {
        print("ShowController Deinit")
    }
}
