//
//  takItem.swift
//  tak
//
//  Created by Elliott Brunet on 13/01/2017.
//  Copyright © 2017 Elliott Brunet. All rights reserved.
//

import Foundation
import RealmSwift

class HealthData: Object {
    
    @objc dynamic var date : NSDate?
    @objc dynamic var type : String?
    @objc dynamic var size : String?
    @objc dynamic var lastupdate: NSDate?
    
    convenience required init(date: NSDate, type: String, size: String, lastupdate: NSDate) {
        self.init()
        self.date = date
        self.type = type
        self.size = size
        self.lastupdate = lastupdate
    }
    
}
