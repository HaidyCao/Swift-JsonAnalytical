//
//  ViewController.swift
//  Swift-Json
//
//  Created by HD on 15/7/3.
//  Copyright © 2015年 Haidy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let json: AnyObject = [
            "name": "LiSi",
            "age": 29,
            "childs":
            [
                ["name": "LiZhi", "age": 1],
                ["name": "LiZhiYi", "age": 2],
                ["name": "LiZhiEr", "age": 3]
            ]
        ]
        
        let persion: AnyObject! = Json.jsonToModel(json, className: "Persion")
        
        if persion != nil {
            print((persion as! Persion).name)
        } else {
        }
        
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        titleView.backgroundColor = UIColor.redColor()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "确定", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        self.navigationItem.titleView = titleView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class Persion: NSObject {
    var name: String!
    var age: Int = 0
    var childs: [Child]!
}

class Child: NSObject {
    var name: String!
    var age: Int = 0
}