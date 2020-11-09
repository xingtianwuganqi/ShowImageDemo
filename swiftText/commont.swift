//
//  commont.swift
//  swiftText
//
//  Created by 景军 on 2018/1/2.
//  Copyright © 2018年 景军. All rights reserved.
//

import UIKit

let Bold    = "PingFangSC-Semibold"
let Medium  = "PingFangSC-Medium"
let Regular = "PingFangSC-Regular"

func printLog<N>(message:N,fileName:String = #file,methodName:String = #function,lineNumber:Int = #line){
    #if DEBUG
    print("message:\(message)\nway:\(fileName as NSString) methods:\(methodName) line:\(lineNumber)")
    #endif
}




