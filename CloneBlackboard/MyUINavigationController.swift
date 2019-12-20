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
        navigationBar.barTintColor = UIColor(hex: "7c5f3d", alpha: 0.8)
        // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        navigationBar.tintColor = UIColor(hex: "fafffb")
        // ナビゲーションバーのテキストを変更する
        navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor: UIColor(hex: "fafffb")
        ]
        // Do any additional setup after loading the view.
    }
}
