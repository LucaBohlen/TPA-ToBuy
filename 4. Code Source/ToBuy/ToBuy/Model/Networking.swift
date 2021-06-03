//  ETML
//  Auteur : Luca Bohlen
//  Date : 12.05.2021
//  Description : Ce script gère les appels à la base de données créant de nouvelles données dans la base de données et récupérant les données.

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class Networking{
    
    static var shared = Networking()
    private let db = Firestore.firestore()
    
    private init(){}
    
    func signIn(email:String, password:String, completion: @escaping (_ error: String?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password, completion: {(user,error) in
            if let error = error{
                completion(error.localizedDescription)
            }else{
                if let error = error{
                    completion(error.localizedDescription)
                }else{
                    self.db.collection("Users").document(Auth.auth().currentUser!.uid).getDocument { (snap, error) in
                        if let data = snap?.data(){
                            let user = User(data: data)
                            Public.user = user
                            completion(nil)
                        }else{
                            completion("Erreur : impossible de créer un compte")
                        }
                    }
                }
            }
        })
    }
    
    func signUp(name: String, email: String, password:String, completion: @escaping (_ error: String?) -> ()){
        Auth.auth().createUser(withEmail: email, password: password, completion: {(_user, error) in
            if let error = error{
                completion(error.localizedDescription)
            }else{
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.commitChanges(completion: {(error) in
                    if let _ = error{
                        completion(nil)
                    }else{
                        let user = User(uid: Auth.auth().currentUser!.uid, name: name, email: email)
                        Public.user = user
                        self.createUser(user: user, completion: {(error) in
                            if let error = error{
                                completion(error)
                            }else{
                                Public.user = user
                                completion(nil)
                            }
                        })
                    }
                })
            }
        })
    }
    
    private func createUser(user: User, completion: @escaping (_ error: String?) -> ()){
        let batch = self.db.batch()
        batch.setData(user.json, forDocument: self.db.collection("Users").document(user.uid))
        let categoryLocationMigros = ["Vegetables": "Isle 1", "Dairy product": "Isle 2", "Meat": "Isle 3", "Drinks": "Isle 4", "Fresh frozen": "Isle 5", "Games": "Isle 6"]
        let categoryLocationCoop = ["Vegetables": "Isle 1", "Drinks": "Isle 2", "Meat": "Isle 3", "Dairy product": "Isle 4", "Fresh frozen": "Isle 5", "Games": "Isle 6"]
        let categoryLocationAldi = ["Drinks": "Isle 1", "Vegetables": "Isle 2", "Dairy product": "Isle 3", "Fresh frozen": "Isle 4", "Meat": "Isle 5", "Games": "Isle 6"]
        let ref1 = self.db.collection("Shops").document()
        let shop1 = Shop(id: ref1.documentID, name: "Aldi", dateAdded: Date(), shopLocation: "Lausanne", categoryLocation: categoryLocationAldi, uid: Public.user.uid)
        batch.setData(user.json, forDocument: self.db.collection("Users").document(user.uid))
        let ref2 = self.db.collection("Shops").document()
        let shop2 = Shop(id: ref2.documentID, name: "Migros", dateAdded: Date(), shopLocation: "Lausanne", categoryLocation: categoryLocationMigros, uid: Public.user.uid)
        batch.setData(user.json, forDocument: self.db.collection("Users").document(user.uid))
        let ref3 = self.db.collection("Shops").document()
        let shop3 = Shop(id: ref3.documentID, name: "Coop", dateAdded: Date(), shopLocation: "Lausanne", categoryLocation: categoryLocationCoop, uid: Public.user.uid)
        batch.setData(user.json, forDocument: self.db.collection("Users").document(user.uid))
        batch.setData(shop1.json, forDocument: ref1)
        batch.setData(shop2.json, forDocument: ref2)
        batch.setData(shop3.json, forDocument: ref3)
        batch.commit { (error) in
            if let error = error{
                completion(error.localizedDescription)
            }else{
                completion(nil)
            }
        }
    }
    
    func fetchUser(uid:String, completion: @escaping (_ error: String? , _ user: User?) -> ()){
        self.db.collection("Users").document(uid).getDocument { (snapShot, error) in
            if let err = error{
                completion(err.localizedDescription,nil)
            }else if let data = snapShot?.data(){
                completion(nil, User(data: data))
            }
        }
    }
    
    func getShoppingList(uid:String, completion: @escaping (_ error: String? , _ shoppingList: [ShoppingList]?) -> ()){
        self.db.collection("ShoppingList").whereField("uid", isEqualTo: uid).addSnapshotListener { (snap, error) in
            if let err = error{
                completion(err.localizedDescription,nil)
            }else if let snap = snap{
                var arr = [ShoppingList]()
                for i in snap.documents{
                    arr.append(ShoppingList(data: i.data()))
                }
                completion(nil, arr)
            }
        }
    }
    
    func getShops(uid:String, completion: @escaping (_ error: String? , _ shoppingList: [Shop]?) -> ()){
        self.db.collection("Shops").whereField("uid", isEqualTo: uid).addSnapshotListener { (snap, error) in
            if let err = error{
                completion(err.localizedDescription,nil)
            }else if let snap = snap{
                var arr = [Shop]()
                for i in snap.documents{
                    arr.append(Shop(data: i.data()))
                }
                completion(nil, arr)
            }
        }
    }
    
    func addShop(shop: Shop, completion: @escaping (_ error: String?) -> ()){
        let ref = self.db.collection("Shops").document()
        var shop = shop
        shop.id = ref.documentID
        ref.setData(shop.json) { (error) in
            if let err = error{
                completion(err.localizedDescription)
            }else{
                completion(nil)
            }
        }
    }
    
    func getShop(id: String, completion: @escaping (_ error: String?, _ shop: Shop?) -> ()){
        self.db.collection("Shops").document(id).addSnapshotListener({ (snap, error) in
            if let err = error{
                completion(err.localizedDescription, nil)
            }else if let data = snap?.data(){
                completion(nil, Shop(data: data))
            }else{
                completion(nil, nil)
            }
        })
    }
    
    func editShop(shop: Shop, completion: @escaping (_ error: String?) -> ()){
        let ref = self.db.collection("Shops").document(shop.id)
        ref.setData(shop.json) { (error) in
            if let err = error{
                completion(err.localizedDescription)
            }else{
                completion(nil)
            }
        }
    }
    
    func deleteShop(id: String, completion: @escaping (_ error: String?) -> ()){
        self.db.collection("Shops").document(id).delete { (error) in
            if let err = error{
                completion(err.localizedDescription)
            }else{
                completion(nil)
            }
        }
    }
    
    func addShoppingItem(shoppingItem: ShoppingList, completion: @escaping (_ error: String?) -> ()){
        let ref = self.db.collection("ShoppingList").document()
        var shoppingItem = shoppingItem
        shoppingItem.id = ref.documentID
        ref.setData(shoppingItem.json) { (error) in
            if let err = error{
                completion(err.localizedDescription)
            }else{
                completion(nil)
            }
        }
    }
    
    func editShoppingItem(shoppingItem: ShoppingList, completion: @escaping (_ error: String?) -> ()){
        self.db.collection("ShoppingList").document(shoppingItem.id).updateData(shoppingItem.json) { (error) in
            if let err = error{
                completion(err.localizedDescription)
            }else{
                completion(nil)
            }
        }
    }
    
    func deleteShoppingListItem(id: String, completion: @escaping (_ error: String?) -> ()){
        self.db.collection("ShoppingList").document(id).delete { (error) in
            if let err = error{
                completion(err.localizedDescription)
            }else{
                completion(nil)
            }
        }
    }
    
    func deleteShoppingList(ids: [String], completion: @escaping (_ error: String?) -> ()){
        let batch = self.db.batch()
        for i in ids{
            batch.deleteDocument(self.db.collection("ShoppingList").document(i))
        }
        batch.commit { (error) in
            if let err = error{
                completion(err.localizedDescription)
            }else{
                completion(nil)
            }
        }
    }
    
}
