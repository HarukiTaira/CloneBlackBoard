//
//  PagingMenuViewController.swift
//  CloneBlackboard
//
//  Created by 平良悠貴 on 2019/11/07.
//  Copyright © 2019 平良悠貴. All rights reserved.
//

import Foundation
import Tabman
import Pageboy

var Array = ["テキスト","画像"]


class PagingMenuViewController: TabmanViewController {
    
    var passedModel :TodoRealm!
    var passedText : String!
    var passedImage: UIImage!
    var passedTitle: String!
    var passedDetail:String!
    var passedSaveImage:UIImage!
    var isNew = true
    var passedID: Int!
    
    private lazy var viewControllers: [UIViewController] = {
        [
            storyboard!.instantiateViewController(withIdentifier: "TextViewController"),
            storyboard!.instantiateViewController(withIdentifier: "ImageViewController")
        ]
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.dataSource = self
        
        let  bar = TMBar.ButtonBar()
        bar.backgroundView.style = .blur(style: .light)
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        bar.layout.contentMode = .intrinsic
        bar.layout.alignment = .leading
        bar.buttons.customize { (button) in
            button.selectedTintColor = UIColor(hex: "353c3f")
            button.tintColor = UIColor(hex: "353c3f", alpha: 0.3)
        }
        bar.indicator.tintColor = UIColor(hex: "7c5f3d")
        bar.indicator.overscrollBehavior = .bounce
        bar.indicator.weight = .medium
        
        addBar(bar, dataSource:  self, at: .top)
        
        configureViewController()
    }
    
    func configureViewController(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: .main)
        let imageVC = mainStoryboard.instantiateViewController(identifier: "ImageViewController") as! ImageViewController
        imageVC.passedImage2 = (passedSaveImage != nil) ? passedSaveImage : passedImage
        
        let textVC = mainStoryboard.instantiateViewController(withIdentifier: "TextViewController") as! TextViewController
        textVC.isNew = isNew
        textVC.passedID = passedID
        if passedDetail == nil{
            textVC.passedText2 = passedText
        } else{
            textVC.passedText2 = passedDetail
        }
        if passedSaveImage == nil{
            textVC.passedImageSave = passedImage
        }else{
            textVC.passedImageSave = passedSaveImage
        }
        if passedTitle == nil{
            textVC.passedTitle2 = ""
        }else{
            textVC.passedTitle2 = passedTitle
        }
        
        
        viewControllers = [ textVC, imageVC]
        self.dataSource = self
    }
    
}
//MARK:TMbar
extension PagingMenuViewController: PageboyViewControllerDataSource,TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title =  Array[(index)]
        return TMBarItem(title: title)
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}

//MARK:UIColor
extension UIColor {
    convenience init(hex: String, alpha: CGFloat) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1.0)
    }
}
