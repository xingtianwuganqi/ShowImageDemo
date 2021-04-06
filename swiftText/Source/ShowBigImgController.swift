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
    
    private let SystemNaviBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height + 44
    
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
        self.saveBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 70, height: 16))
            make.top.equalToSuperview().offset(SystemNaviBarHeight - 20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    // 保存图片
    @objc func saveBtnClick() {
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
    
    deinit {
        print("ShowController Deinit")
    }
    
    func savePhotos(image: UIImage?,data: Data?) {

        PHPhotoLibrary.requestAuthorization { (status) in

            if status == PHAuthorizationStatus.authorized || status == PHAuthorizationStatus.notDetermined {
                PHPhotoLibrary.shared().performChanges {
                    if let data = data {
                        let req = PHAssetCreationRequest.forAsset()
                        req.addResource(with: .photo, data: data, options: nil)
                    }else if let img = image{
                        _ = PHAssetChangeRequest.creationRequestForAsset(from: img)
                    }
                    
                    
                } completionHandler: { (finish, error) in
                    DispatchQueue.main.async {
                        self.showAlertInfo(success: finish)
                    }
                }

            }else{
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
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let hud = MBProgressHUD.showAdded(to: self.showView, animated: true)
        hud.mode = .text
        hud.bezelView.style = .solidColor
        hud.bezelView.color = UIColor.black
        hud.label.font = UIFont.systemFont(ofSize: 14)
        hud.label.textColor = .white
        if error != nil {
            hud.label.text = "保存失败"
        } else {
            hud.label.text = "保存成功"
        }
        hud.show(animated: true)
        hud.hide(animated: true, afterDelay: 1.5)

    }
    
    func showAlertInfo(success: Bool) {
        let hud = MBProgressHUD.showAdded(to: self.showView, animated: true)
        hud.mode = .text
        hud.bezelView.style = .solidColor
        hud.bezelView.color = UIColor.black
        hud.label.font = UIFont.systemFont(ofSize: 14)
        hud.label.textColor = .white
        if success {
            hud.label.text = "保存成功"
        } else {
            hud.label.text = "保存失败"
        }
        hud.show(animated: true)
        hud.hide(animated: true, afterDelay: 1.5)
    }
}
