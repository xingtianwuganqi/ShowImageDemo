//
//  ShowBigImgController.swift
//  rebate
//
//  Created by jingjun on 2020/4/20.
//  Copyright © 2020 寻宝天行. All rights reserved.
//

import UIKit
import Photos
import MBProgressHUD

public class ShowBigImgController: UIViewController {
    
    private let SystemNaviBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height + 24
    
    /// 默认不显示
    public var showSaveBtn: Bool = false {
        didSet {
            if showSaveBtn {
                self.saveBtn.isHidden = false
            }else{
                self.saveBtn.isHidden = true
            }
        }
    }
    
    /// 可重写saveBtn样式
    public lazy var saveBtn: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("保存至相册", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.isHidden = true
        return button
    }()
    
    internal var showView: ShowBigImgBackView
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
        self.layoutViews()
        self.saveBtn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
    }
    
    func layoutViews() {
        self.view.addSubview(self.showView)
        self.view.addSubview(self.saveBtn)
        self.showView.dismissCallBack = { [weak self] in
            self?.dismiss(animated: false, completion: nil)
        }
        self.saveBtn.translatesAutoresizingMaskIntoConstraints = false
        self.saveBtn.heightAnchor.constraint(equalToConstant: 16).isActive = true
        self.saveBtn.widthAnchor.constraint(equalToConstant: 70).isActive = true
        self.saveBtn.topAnchor.constraint(equalTo: self.view.topAnchor, constant: SystemNaviBarHeight).isActive = true
        self.saveBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
    }
    
    // 保存图片
    @objc func saveBtnClick() {
        DispatchQueue.main.async {
            MBProgressHUD.xy_show(activity: "保存中...")
        }
        let index = Int(self.showView.collectionView.contentOffset.x / ScreenW)
        
        if self.showView.urlArr.count > 0 {
            let url = self.showView.urlArr[index]
            guard let data = try? Data.init(contentsOf: URL(string: url)!) else {
                return
            }
            self.savePhotos(image: nil, data: data)
        }else{
            let img = self.showView.imgArr[index]
            self.savePhotos(image: img, data: nil)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showView.transformAnimation()
    }
    
//    deinit {
//        print("ShowController Deinit")
//    }
    
    func savePhotos(image: UIImage?,data: Data?) {
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == PHAuthorizationStatus.authorized || status == PHAuthorizationStatus.notDetermined {
                PHPhotoLibrary.shared().performChanges {
                    if let imgData = data {
                        let req = PHAssetCreationRequest.forAsset()
                        req.addResource(with: .photo, data: imgData, options: nil)
                    }else if let img = image{
                        _ = PHAssetChangeRequest.creationRequestForAsset(from: img)
                    }else{
                        MBProgressHUD.xy_hide()
                        return
                    }
                } completionHandler: { (finish, error) in
                    DispatchQueue.main.async {
                        if finish {
                            MBProgressHUD.xy_hide()
                            MBProgressHUD.xy_show("保存成功")
                        }else{
                            MBProgressHUD.xy_hide()
                            MBProgressHUD.xy_show("保存失败")
                        }
                    }
                };
            }else{
                MBProgressHUD.xy_hide()
                //去设置
                self.openSystemSettingPhotoLibrary()
            }
        }
    }
    
    func openSystemSettingPhotoLibrary() {
        let alert = UIAlertController(title:"未获得权限访问您的照片", message:"请在设置选项中允许访问您的照片", preferredStyle: .alert)
        let confirm = UIAlertAction(title:"去设置", style: .default) { (_)in
            let url=URL.init(string: UIApplication.openSettingsURLString)
            if  UIApplication.shared.canOpenURL(url!){
                UIApplication.shared.open(url!, options: [:], completionHandler: { (ist)in
                })
            }
        }
        let cancel = UIAlertAction(title:"取消", style: .cancel, handler:nil)
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.present(alert, animated:true, completion:nil)
    }
}
