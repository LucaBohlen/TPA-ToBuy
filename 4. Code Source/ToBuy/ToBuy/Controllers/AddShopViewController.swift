//  ETML
//  Auteur : Luca Bohlen
//  Date : 12.05.2021
//  Description : Ce script gère la page de liste d'ajout de magasin.

import UIKit
import MBProgressHUD

class AddShopViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var location: DesignableUITextField!
    
    var items = [Shop]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func add(_ sender: Any) {
        if let name = self.name.text, let location = self.location.text{
            if name == ""{
                self.showAlert(title: "Erreur", message: "Entrer un nom de magasin") { (_) in }
                return
            }
            if location == ""{
                self.showAlert(title: "Erreur", message: "Entrer une location") { (_) in }
                return
            }
            if ["Aldi", "Migros", "Coop"].contains(name){
                self.showAlert(title: "Erreur", message: "Magasin avec le nom \(name) existe déjà") { (_) in }
                return
            }
            if self.items.contains(where: {$0.name == name}){
                self.showAlert(title: "Erreur", message: "Magasin avec le nom \(name) existe déjà") { (_) in }
                return
            }
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let shop = Shop(id: "", name: name, dateAdded: Date(), shopLocation: location, categoryLocation: [String: String](), uid: Public.user.uid)
            Networking.shared.addShop(shop: shop) { (error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if let error = error{
                    self.showAlert(title: "Erreur", message: error) { (_) in }
                }else{
                    self.showAlert(title: "Succès", message: "Magasin crée et ajouté à la liste") { (_) in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }

}
