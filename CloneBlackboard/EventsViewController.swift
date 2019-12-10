//
//  EventsViewController.swift
//  CloneBlackboard
//
//  Created by 平良悠貴 on 2019/11/19.
//  Copyright © 2019 平良悠貴. All rights reserved.
//

import UIKit
import RealmSwift

class EventsViewController: UIViewController {
    
    var date:String!
    
    @IBOutlet var eventText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func eventInsert(sender:UIButton){
        print("データ書き込み開始")

        do{
            let realm = try! Realm()

            try! realm.write {
                //日付表示の内容とスケジュール入力の内容が書き込まれる。
                let Events = [TodoRealm(value: ["date": y_text.text, "event": eventText.text])]
                realm.add(Events)
                print("データ書き込み中")
            }
        }catch let error as NSError{
            print(error.localizedDescription)
        }

        print("データ書き込み完了")

        //前のページに戻る
        dismiss(animated: true, completion: nil)
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
