//  ETML
//  Auteur : Luca Bohlen
//  Date : 12.05.2021
//  Description : Ce script gère la liaison avec la base de données pour les magasins.

import Foundation
import FirebaseFirestore

struct Shop{
    
    var id: String
    var uid = ""
    var name: String
    var dateAdded: Date
    var shopLocation: String
    var categoryLocation: [String: String]
    
    var json: [String: Any] {
      return [
        "id": self.id,
        "name": self.name,
        "dateAdded": Timestamp(date: self.dateAdded),
        "shopLocation": self.shopLocation,
        "categoryLocation": self.categoryLocation,
        "uid": self.uid
      ]
    }
 
    init(id: String, name: String, dateAdded: Date, shopLocation: String, categoryLocation: [String: String], uid: String){
        self.id = id
        self.uid = uid
        self.name = name
        self.dateAdded = dateAdded
        self.shopLocation = shopLocation
        self.categoryLocation = categoryLocation
    }
    
    init(data: [String: Any]){
        self.id = data["id"] as! String
        self.name = data["name"] as! String
        self.dateAdded = (data["dateAdded"] as! Timestamp).dateValue()
        self.shopLocation = data["shopLocation"] as! String
        self.uid = data["uid"] as! String
        self.categoryLocation = data["categoryLocation"] as! [String: String]
    }
    
}
