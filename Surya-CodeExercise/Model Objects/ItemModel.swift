//
//  ItemModel.swift
//  Surya-CodeExercise
//
//  Created by Mayur on 05/08/17.
//  Copyright © 2017 Mayur. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class Item: Object {
    //Reviewer's Notes: At the time of writing this code, the assumption was that emailID will be treated as the 'primary key'. This is why it's the only property that is treated as a non-optional.
    dynamic var emailID = ""
    dynamic var imageURL: String? = nil
    dynamic var firstName: String? = nil
    dynamic var lastName: String? = nil
    
    override static func primaryKey() -> String? {
        return "emailID"
    }
    
    /// Initialises an Item from a JSON object. If an emailID field is not found in the json, the object won't be initialised.
    convenience init?(from json: JSON) {
        guard let emailString = json["emailId"].string else { return nil }
        self.init()
        emailID = emailString
        imageURL = json["imageUrl"].string
        firstName = json["firstName"].string
        lastName = json["lastName"].string
    }
}


