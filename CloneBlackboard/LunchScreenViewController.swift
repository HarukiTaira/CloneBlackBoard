//
//  LunchScreenViewController.swift
//  CloneBlackboard
//
//  Created by 平良悠貴 on 2019/12/17.
//  Copyright © 2019 平良悠貴. All rights reserved.
//

import UIKit

class LunchScreenViewController: UIViewController {
    
  @IBOutlet var imageview : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.5,
                       options: .curveEaseOut,
                       animations: {()
                        self.imageview.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    
        },completion: {
            (Bool)in
        })
        UIView.animate(withDuration: 0.2,
                       delay: 1.3,
                       options: .curveEaseOut,
                       animations: {()
                        self.imageview.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)
                        self.imageview.alpha = 0
        },completion: {
            (Bool)in
            self.imageview.removeFromSuperview()
        })
        
        
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
