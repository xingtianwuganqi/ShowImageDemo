//
//  HomePageController.swift
//  swiftText
//
//  Created by jingjun on 2018/8/28.
//  Copyright © 2018年 景军. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class HomePageController: UIViewController {

    let imageArr = ["https://n.sinaimg.cn/tech/transform/326/w186h140/20210406/287f-knipfse7144059.gif",
                    "http://img.sccnn.com/bimg/337/23926.jpg",
                    "http://pic37.huitu.com/res/20150926/709_20150926211750111200_1.jpg",
                    "http://img.pconline.com.cn/images/photoblog/2/5/2/6/2526376/20069/18/1158593819487.jpg",
                    "http://pic38.nipic.com/20140213/12403214_222400981002_2.jpg"]
    lazy var tableview : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.estimatedRowHeight = 0
        table.estimatedSectionFooterHeight = 0
        table.estimatedSectionHeaderHeight = 0
        table.delegate = self
        table.dataSource = self
        table.register(imageCell.self, forCellReuseIdentifier: "imageCell")
        return table
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUI()
    }
    
    func setUI() {
        self.view.addSubview(self.tableview)
        tableview.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalToSuperview()
            }
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func showImg (imgs: [String],url: String) {
        let showController = ShowBigImgController(urls: imgs, url: url)
        showController.modalPresentationStyle = .overFullScreen
        showController.showSaveBtn = true
        self.present(showController, animated: false, completion: nil)
    }
}
extension HomePageController :UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.imageArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: imageCell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! imageCell
        cell.imageview.sd_setImage(with: URL(string: self.imageArr[indexPath.row]), completed: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = self.imageArr[indexPath.row]
        self.showImg(imgs: self.imageArr, url: url)
    }
}

class imageCell: UITableViewCell {
    lazy var imageview : UIImageView = {
        let imagev = UIImageView()
        return imagev
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(self.imageview)
        imageview.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}
