//  ETML
//  Auteur : Luca Bohlen
//  Date : 12.05.2021
//  Description : Ce script gère la liaison avec la base de données pour l'utilisateur.

import Foundation

struct User{
    
    var uid: String
    var name: String
    var email: String
    
    var json: [String: Any] {
      return [
        "uid": self.uid,
        "name": self.name,
        "email": self.email
      ]
    }
 
    init(uid: String, name: String, email: String){
        self.uid = uid
        self.name = name
        self.email = email
    }
    
    init(data: [String: Any]){
        self.uid = data["uid"] as! String
        self.name = data["name"] as! String
        self.email = data["email"] as! String
    }
    
}
