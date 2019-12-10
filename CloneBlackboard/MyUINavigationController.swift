//
//  MyUINavigationController.swift
//  CloneBlackboard
//
//  Created by 平良悠貴 on 2019/11/08.
//  Copyright © 2019 平良悠貴. All rights reserved.
//

import UIKit

class MyUINavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //　ナビゲーションバーの背景色
        navigationBar.barTintColor = UIColor(hex: "ff8d3f", alpha: 0.8)
        // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        navigationBar.tintColor = UIColor(hex: "353c3f")
        // ナビゲーションバーのテキストを変更する
        navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor: UIColor(hex: "353c3f")
        ]
        // Do any additional setup after loading the view.
    }
}
