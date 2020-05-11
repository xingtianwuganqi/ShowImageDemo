//
//  ListViewController.swift
//  swiftText
//
//  Created by jingjun on 2018/8/28.
//  Copyright © 2018年 景军. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    let imageArr = [UIImage(named: "16a521d332df104d.jpg"),UIImage(named: "avator.png"),UIImage(named: "head.jpg"),UIImage(named: "long.jpg")]
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func showImg (imgs: [UIImage],img: UIImage) {
        let controller = ShowBigImgController(imgs: imgs, img: img)
        controller.modalPresentationStyle = .overFullScreen
        self.present(controller, animated: false, completion: nil)
    }
}
extension ListViewController :UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.imageArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: imageCell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! imageCell
        cell.imageview.image = self.imageArr[indexPath.row]
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
        guard let image = self.imageArr[indexPath.row] else {
            return
        }
        guard let imgs = self.imageArr as? [UIImage] else {
            return
        }
        self.showImg(imgs: imgs, img: image)
    }
}
