//
//  TextViewController.swift
//  CloneBlackboard
//
//  Created by 平良悠貴 on 2019/11/12.
//  Copyright © 2019 平良悠貴. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import NYXImagesKit
import Material

class TextViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    var passedModel: TodoRealm?
    var realmDate:[TodoRealm] = []
    var passedText2 : String!
    var passedImageSave :UIImage!
    var passedTitle2:String!
    var textlist : Results<TodoRealm>!
    var passedID: Int!
    var isNew = true
    
    
    @IBOutlet var textView:UITextView!
    @IBOutlet var textField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textField.delegate = self
        
        
        if !isNew {
            textView.text = passedText2
            textField.text = passedTitle2
        } else {
            textView.text = passedText2
            textField.text = passedTitle2
        }
        
        // Do any additional setup after loading the view.
        
        
        
    }
//    @IBAction func snsButton(){
//        let text = "何かデフォルトで欄に入っててほしい文字列"
//        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        if let encodedText = encodedText,
//            let url = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
//    }
    @IBAction func ActivityButton(){
        if let sharetext = textView.text {
          //UIActivityViewControllerに渡す配列
          let shareItems = [sharetext]

          //UIActivityViewControllerにシェア画像を渡す
          let controller = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
            self.present(controller, animated: true, completion: nil)
        }

    }
    @IBAction func saveButton(){
        let button = RaisedButton()
        view.layout(button)
            .width(ButtonLayout.Raised.width)
            .height(ButtonLayout.Raised.height)
            .center(offsetY:ButtonLayout.Raised.offsetY)
        if !isNew {
            guard let id = passedID else {
                print("IDガアリマセン")
                return
            }
            // 更新の場合
            let alertController = UIAlertController(title: "更新",message: "更新します。よろしいですか？", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){ (action: UIAlertAction) in
               do {
                   let realm = try Realm()
                   let todo = realm.objects(TodoRealm.self).filter("id==\(id)").first
                todo?.update(title: self.textField.text!, detail: self.textView.text!)
                   print("こうしんできました！！！")
                   self.navigationController?.popViewController(animated: true)
               } catch let error as NSError {
                   print(error.localizedDescription)
               }
                
            }
            let cancelButton = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                
            }
            
            alertController.addAction(okAction)
            alertController.addAction(cancelButton)
            
            // self.present(nextView, animated: true, completion: nil)
            present(alertController,animated: true,completion: nil)
//            do {
//                let realm = try Realm()
//                let todo = realm.objects(TodoRealm.self).filter("id==\(id)").first
//                todo?.update(title: textField.text!, detail: textView.text!)
//                print("こうしんできました！！！")
//                self.navigationController?.popViewController(animated: true)
//            } catch let error as NSError {
//                print(error.localizedDescription)
//            }
        } else {
            let returnStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
            let returnView = returnStoryboard.instantiateViewController(withIdentifier: "listViewController") as! ListViewController
            
            let dt = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
            print("dateFormatter" + dateFormatter.string(from: dt))
            
            guard let customMemo = TodoRealm.create() else {
                print("保存失敗")
                return
            }
            customMemo.title = textField.text!
            customMemo.detail = textView.text!
            customMemo.time = dateFormatter.string(from: dt)
            let image = passedImageSave
            let resizeImage = image?.scale(byFactor:1.0)
            customMemo.image = resizeImage
            
            let alertController = UIAlertController(title: "保存",message: "保存します。よろしいですか？", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){ (action: UIAlertAction) in
                customMemo.save()
//                self.show(returnView, sender: nil)
                self.navigationController?.popToRootViewController(animated: true)
                
            }
            let cancelButton = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                
            }
            
            alertController.addAction(okAction)
            alertController.addAction(cancelButton)
            
            // self.present(nextView, animated: true, completion: nil)
            present(alertController,animated: true,completion: nil)
        }
        
    }
    
}
