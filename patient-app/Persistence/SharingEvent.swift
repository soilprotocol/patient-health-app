//
//  SharingEvent.swift
//  patient-app
//
//  Created by Elliott Brunet on 06.06.19.
//  Copyright © 2019 Elliott Brunet. All rights reserved.
//

import Foundation
import RealmSwift

class SharingEvent: Object {
    
    @objc dynamic var timestamp : NSDate?
    @objc dynamic var type : String?
    @objc dynamic var numberOfElmentsShared : String?
    @objc dynamic var sharingWithPerson: String?
    @objc dynamic var sharingWithInstitution: String?
    @objc dynamic var dateStart: NSDate?
    @objc dynamic var dateEnd: NSDate?
    @objc dynamic var sharing: String?
    
    convenience required init(timestamp: NSDate, type: String,numberOfElmentsShared: String, sharingWithPerson: String, dateStart: NSDate, dateEnd: NSDate, sharing: String) {
        self.init()
        self.timestamp = timestamp
        self.type = type
        self.numberOfElmentsShared = numberOfElmentsShared
        self.sharingWithPerson = sharingWithPerson
        self.sharingWithInstitution = sharingWithInstitution
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.sharing = sharing
    }
    
}
