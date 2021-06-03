//  ETML
//  Auteur : Luca Bohlen
//  Date : 12.05.2021
//  Description : Ce script gère la liaison avec la base de données pour la liste des courses.

import Foundation
import FirebaseFirestore

struct ShoppingList{
    
    var id = ""
    var name: String
    var dateAdded: Date
    var quantity: Int
    var category: String
    var uid: String
    
    var json: [String: Any] {
      return [
        "id": self.id,
        "name": self.name,
        "dateAdded": Timestamp(date: self.dateAdded),
        "quantity": self.quantity,
        "category": self.category,
        "uid": self.uid
      ]
    }
 
    init(name: String, dateAdded: Date, quantity: Int, category: String, uid: String){
        self.name = name
        self.dateAdded = dateAdded
        self.quantity = quantity
        self.category = category
        self.uid = uid
    }
    
    init(data: [String: Any]){
        self.id = data["id"] as! String
        self.name = data["name"] as! String
        self.dateAdded = (data["dateAdded"] as! Timestamp).dateValue()
        self.quantity = data["quantity"] as! Int
        self.category = data["category"] as! String
        self.uid = data["uid"] as! String
    }
    
}
