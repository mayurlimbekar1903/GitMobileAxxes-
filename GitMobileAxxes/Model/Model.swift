//
//  Model.swift
//  MobileAxxess_Mayur_Limbekar
//
//  Created by Admin on 18/08/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class Model: Object,Decodable {
      @objc dynamic var id: String = ""
      @objc dynamic var type: String?
      @objc dynamic var date: String?
      @objc dynamic var data: String?

    override class func primaryKey() -> String? {
        return "id"
    }
}

