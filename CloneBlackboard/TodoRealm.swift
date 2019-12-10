//
//  TodoRealm.swift
//  CloneBlackboard
//
//  Created by 平良悠貴 on 2019/11/08.
//  Copyright © 2019 平良悠貴. All rights reserved.
//

import UIKit
import RealmSwift
import Realm


class TodoRealm: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var title: String = ""
    @objc dynamic var detail: String = ""
    @objc dynamic var time: String = ""
    
    @objc dynamic private var _image: UIImage? = nil
    @objc dynamic private var imageData: NSData? = nil
    @objc dynamic var image: UIImage? {
        
        set{
            self._image = newValue
            if let value = newValue {
                self.imageData = value.pngData() as! NSData
            }
        }get{
            if let image = self._image {
                return image
            }
            if let data = self.imageData {
                self._image = UIImage(data: data as Data)
                return self._image
            }
            return nil
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["image", "_image"]
    }
    
    static func create() -> TodoRealm?{
        guard let id = lastId() else { return nil }
        let customMemo = TodoRealm()
        customMemo.id = id
        return customMemo
    }
    
    static func loadAll() -> [TodoRealm]? {
        do {
            let realm = try Realm()
            let memos = realm.objects(TodoRealm.self).sorted(byKeyPath: "id", ascending: false)
            var memoArray: [TodoRealm] = []
            for memo in memos {
                memoArray.append(memo)
            }
            return memoArray
        } catch let error as NSError {
            // handle error
            print(error.localizedDescription)
            return nil
        }
        
    }
    static func deleteAll() {
        do {
            let realm = try Realm()
            let memos = realm.objects(TodoRealm.self)
            do {
                try realm.write {
                    realm.delete(memos)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    static func lastId() -> Int? {
        do {
            let realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            if let memo = realm.objects(TodoRealm.self).last {
                return memo.id + 1
            } else {
                return 1
            }
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
        
    }
    func update(title: String, detail: String){
        do {
            let realm = try Realm()
            do {
                try realm .write {
                    self.title = title
                    self.detail = detail
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    func save() {
        do {
            let realm = try Realm()
            do {
                try realm.write {
                    realm.add(self)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
