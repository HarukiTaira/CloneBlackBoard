//
//  Event.swift
//  CloneBlackboard
//
//  Created by 平良悠貴 on 2019/11/23.
//  Copyright © 2019 平良悠貴. All rights reserved.
//

import Foundation
import RealmSwift

class Event: Object{
    @objc dynamic var date: String = ""
    @objc dynamic var event: String = ""
}
