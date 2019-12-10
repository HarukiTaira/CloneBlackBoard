//
//  ImageViewController.swift
//  CloneBlackboard
//
//  Created by 平良悠貴 on 2019/11/12.
//  Copyright © 2019 平良悠貴. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    var passedModel : TodoRealm?
    var passedImage2 : UIImage!
    
    @IBOutlet var imageView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = passedImage2
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
