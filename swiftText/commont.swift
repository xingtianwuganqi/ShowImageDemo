//
//  commont.swift
//  swiftText
//
//  Created by 景军 on 2018/1/2.
//  Copyright © 2018年 景军. All rights reserved.
//

import UIKit
//宏
let ScreenW = UIApplication.shared.statusBarOrientation.isLandscape ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.width
let ScreenH = UIApplication.shared.statusBarOrientation.isLandscape ? UIScreen.main.bounds.size.width : UIScreen.main.bounds.size.height
let Bold    = "PingFangSC-Semibold"
let Medium  = "PingFangSC-Medium"
let Regular = "PingFangSC-Regular"

func printLog<N>(message:N,fileName:String = #file,methodName:String = #function,lineNumber:Int = #line){
    #if DEBUG
    print("message:\(message)\nway:\(fileName as NSString) methods:\(methodName) line:\(lineNumber)")
    #endif
}




